# it-590-aws

Collection of example CloudFormation templates, bash shell scripts, Dos/PowerShell scripts, (mostly, for now, bash deployment scripts) and Python code.

**NOTE:** I welcome suggestions for example and pull requests.


## Non-Default Virtual Private Cloud (VPC)
<a href="vpc/">vpc</a>


## EC2 Instance in Public Subnet

<a href="ec2/">ec2</a></br>
**Depends On:** <a href="vpc/">vpc</a>

## EC2 Web Server -- Apache + PHP

<a href="ec2-web">ec2-web</a></br>
**Depends On:** <a href="vpc/">vpc</a>

## Elastic File System (EFS)

<a href="efs">efs</a></br>
**Depends On:** <a href="vpc/">vpc</a>

## Two EC2 Apache Web Servers with Shared EFS Volume

<a href="ec2-web-efs/">ec2-web-efs</a></br>
**Depends On:** <a href="vpc/">vpc</a> && <a href="efs">efs</a></br>

## Lambda Echo Server

<a href="lambda-echo/">lambda-echo</a>

## Lambda Echo Server with Custom RestAPI

<a href="lambda-echo-custom-api/">lambda-echo-custom-api</a>


## Simple Notification Service (SNS)

<a href="sns/">sns</a>

## Simple Queue Service (SQS)

<a href="sqs/">sqs</a>

## Lambda Echo with SNS

<a href="lambda-echo-sns/">lambda-echo-sns</a></br>
**Depends On:** <a href="sns">sns</a>

## DynamoDB

<a href="dynamodb/">dynamodb</a>

## Lambda Echo with SQS, SNS, and DynamoDB

<a href="lambda-echo-sqs-dynamodb/">lambda-echo-sqs-dynamodb</a></br>
**Depends On:** <a href="sns">sns</a> && <a href="sqs">sqs</a>&& <a href="dynamodb">dynamodb</a></br>

## Relational Databae Service (RDS)

<a href="rds/">rds</a></br>
**Depends On:** <a href="vpc/">vpc</a>

## EC2 with Two Web Servers, EFS, and an RDS Management Server

<a href="ec2-web-rds/">ec2-web-rds</a></br>
**Depends On:** <a href="vpc/">vpc</a> && <a href="rds/">rds</a></br>
