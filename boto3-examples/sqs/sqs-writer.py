import boto3
import json

# Assumes a queue with the following name.
# You'll need to change this value to use a queue you create
queue_name = 'dev-Echo-Message-Queue'
sqs = boto3.resource('sqs')
queue = sqs.get_queue_by_name(QueueName=queue_name)


def print_info():
    print('Queue URL:' + queue.url)

def write_message(message):
    try:
        response = queue.send_message(MessageBody=message, DelaySeconds=0,)
        print('"' + message + '"' + ' written to ' + queue_name)
        print('Response: ' + json.dumps(response))
    except Exception as e:
        print(str(e))

def send_messages():
    messages = ['Hello, World!', 'This works!', 'Message 1', 'Message 2']
    for message in messages:
        write_message(message)



if __name__ == '__main__':
    print_info()
    send_messages()
