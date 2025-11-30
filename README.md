# it-590-aws

Collection of example CloudFormation templates, bash shell scripts, and Python code. To run these examples on Windows machines, install <a href="https://git-scm.com/downloads">git</a> with git-bash window.  

**NOTE:** I welcome suggestions for examples and pull requests.
Also, many of these examples depend on and reference resources located in other stacks that are assumed to be deployed. (Cross-Stack References) See the **Depends on** for each repo sub-project below.


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

## DynamoDB Global Table
<a href="dynamodb-global-table">dynamodb-global-table</a></br>
**NOTE:** Deploy this if you want multi-region replication for highly-available (HA) <a href="dynamodb-global-table">Lambda Echo SQS DynamoDB</a> pipelines in multiple regions.

## Lambda Echo with SQS, SNS, and DynamoDB

<a href="lambda-echo-sqs-dynamodb/">lambda-echo-sqs-dynamodb</a></br>
**Depends On:** <a href="sns">sns</a> && <a href="sqs">sqs</a>&& <a href="dynamodb">dynamodb</a></br>

## Relational Database Service (RDS)

<a href="rds/">rds</a></br>
**Depends On:** <a href="vpc/">vpc</a>

## EC2 with Two Web Servers, EFS, and an RDS Management Server

<a href="ec2-web-rds/">ec2-web-rds</a></br>
**Depends On:** <a href="vpc/">vpc</a> && <a href="rds/">rds</a></br>
