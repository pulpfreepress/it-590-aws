import boto3
import json
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('dynamodb_table_name')
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    print("******* Begin Execution *********")
    print("EVENT: " + json.dumps(event))
    json_region = os.environ['AWS_REGION']
    print('JSON Region: ' + json_region)

    try:
        for record in event['Records']:
            print("Record: " + record['body'])
            item = json.loads(record['body'])
            response = table.put_item(Item=item)
            print("DynamoDB put_item Response: " + str(response))
    except Exception as e:
        print("ERROR Processing SQS Records: " + str(e))


    return
