import boto3
import json
import os

client = boto3.client('sns')
topic_arn = os.environ.get('sns_topic_arn')


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

    try:
        response = client.publish(
            TargetArn=topic_arn,
            Message=json.dumps({'default': json.dumps(message)}),
            MessageStructure='json'
            )
        print("SNS Response: " + str(response))
    except Exception as e:
        print("SNS ERROR: " + str(e))

    body = "<h1>" + message + "</h1>"

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
