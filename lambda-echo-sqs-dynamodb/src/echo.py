import boto3
import json
import os
import re

client = boto3.client('sns')
topic_arn = os.environ.get('sns_topic_arn')

sqs = boto3.resource('sqs')
queue_name = os.environ.get('sqs_queue_name')
queue = sqs.get_queue_by_name(QueueName=queue_name)



def lambda_handler(event, context):
    print("******* Begin Execution *********")
    print("EVENT: " + json.dumps(event))
    json_region = os.environ['AWS_REGION']
    print('JSON Region: ' + json_region)
    message = 'Hello, World!'
    if 'queryStringParameters' in event:
        if event['queryStringParameters'] is not None:
            if 'message' in event['queryStringParameters']:
                if event['queryStringParameters']['message'] is not None:
                    message = event['queryStringParameters']['message']

    # Extract user's IP IpAddress from X-Forwarded-For header
    ip = '0.0.0.0'
    try:
        results = re.findall("^\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}", event['headers']['X-Forwarded-For'] )
        print("USER'S IP ADDRESS: " + results[0])
        ip = results[0]
    except Exception as e:
        print("ERROR PARSHING REGEX: " + str(e))

    userAgent = event['requestContext']['identity']['userAgent']
    print('USER-AGENT: ' + userAgent)
    # If Amazon-Route53-Health-Check-Service skip sqs and sns
    if "Amazon-Route53-Health-Check-Service" not in userAgent:
        # Push message into message queue
        item = {}
        try:
            #item['IpAddress'] = event['headers']['X-Forwarded-For']
            item['IpAddress'] = ip
            item['Date'] = event['requestContext']['requestTime']
            item['Message'] = message
            response = queue.send_message(MessageBody=json.dumps(item), DelaySeconds=0,)

        except Exception as e:
            print("SQS ERROR: " + str(e))

        # Publish to Message Topic
        try:
            response = client.publish(
                TargetArn=topic_arn,
                Message=json.dumps({'default': json.dumps(message)}),
                MessageStructure='json'
                )
            print("SNS Response: " + str(response))
        except Exception as e:
            print("SNS ERROR: " + str(e))

    body = "<h1>" + message + " : " + json_region + " </h1>"

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": body
    }

    # return {
    #     "statusCode": 200,
    #     "headers": {
    #         "Content-Type": "application/json"
    #     },
    #     "body": json.dumps({
    #         "Region ": json_region,
    #         "Message": message
    #     })
    # }
