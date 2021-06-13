import boto3
import json
import os

def lambda_handler(event, context):
    print("******* Begin Execution *********")
    print("EVENT: " + json.dumps(event))
    json_region = os.environ['AWS_REGION']
    print('JSON Region: ' + json_region)
    message = event['queryStringParameters']['message']
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Region ": json_region,
            "Message": message
        })
    }
