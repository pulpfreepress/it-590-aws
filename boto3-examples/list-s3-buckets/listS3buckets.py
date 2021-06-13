import boto3


def list_buckets():
    # Retrieve the list of existing buckets
    s3 = boto3.client('s3')
    response = s3.list_buckets()

    # Output the bucket names
    print('Existing buckets:')
    for bucket in response['Buckets']:
        print(f'  {bucket["Name"]}')


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    list_buckets()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
