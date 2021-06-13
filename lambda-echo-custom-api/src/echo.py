import boto3
import json
import os

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
