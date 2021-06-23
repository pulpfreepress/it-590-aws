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

    items = []
    try:
        response = table.scan()
        items = response['Items']

    except Exception as e:
        print("ERROR SCANNING DYNAMODB: " + str(e))


    body = "<h1>" + "Messages" + "</h1></br>"
    body = body + "</br>"
    body = body + '<table style="width:100%;border: 1px solid black">'
    body = body + "<tr><th>Date</th><th>IpAddress</th><th>Message</th></tr>"
    for item in items:
        body = body + "<tr><td>" + item['Date'] + "</td><td>" + item['IpAddress'] + "</td><td>" + item['Message'] + "</td></tr>"

    body = body + "</table>"


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
