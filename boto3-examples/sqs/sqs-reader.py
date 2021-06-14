import boto3
import json

# Assumes a queue with the following name.
# You'll need to change this value to use a queue you create
queue_name = 'dev-Echo-Message-Queue'
sqs = boto3.resource('sqs')
queue = sqs.get_queue_by_name(QueueName=queue_name)

def print_info():
    print('Queue URL:' + queue.url)


def read_messages():
    try:
        messages = queue.receive_messages()
        while len(messages) > 0:
            for message in messages:
                print('message received --> ' + str(message.body))
                message.delete()
            messages = queue.receive_messages()

    except Exception as e:
        print(str(e))



if __name__ == '__main__':
    print_info()
    read_messages()
