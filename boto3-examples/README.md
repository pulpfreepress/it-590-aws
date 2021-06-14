# Boto3 Examples

Boto3 Docs: https://boto3.amazonaws.com/v1/documentation/api/latest/index.html

## Notes on Running the Examples

**My Recommendations:**
- Make sure your AWS CLI is installed and your named accounts and credentials are configured
- Install <a href="https://www.python.org">Python 3.9</a>
- Install <a href="https://pipenv.pypa.io/en/latest/">pipenv</a>
- Put the following line in your .bash_profile: `export PIPENV_VENV_IN_PROJECT="true"`
-- ...or just run it from the bash command line
-- ...or create an environment variable in Windows
- In each directory create a Python3 virtual environment: `pipenv --three`
- Then install boto3: `pipenv install boto3`
- Then run the example(s) in that directory like so:
-- `pipenv run python listS3buckets.py`


## List S3 list S3 Buckets

<a href="list-s3-buckets">list-s3-buckets</a>

## SQS Reader and Writer

<a href="sqs">sqs</a>
