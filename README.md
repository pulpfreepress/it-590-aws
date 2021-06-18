# it-590-aws

Collection of example CloudFormation templates, bash shell scripts, Dos/PowerShell scripts, (mostly, for now, bash deployment scripts) and Python code.

**NOTE:** I welcome suggestions for example and pull requests.


## Non-Default Virtual Private Cloud (VPC)
<a href="vpc/">vpc</a>


## EC2 Instance in Public Subnet

<a href="ec2/">ec2</a></br>
**Depends On:** <a href="vpc/">vpc</a>

## EC2 Web Server -- Apache + PHP

<a href="ec2-web/">ec2-web</a></br>
**Depends On:** <a href="vpc/">vpc</a>

## Elastic File System (EFS)

<a href="efs">efs/</a></br>
**Depends On:** <a href="vpc/">vpc</a>

## Two EC2 Apache Web Servers with Shared EFS Volume

<a href="ec2-web-efs/">ec2-web-efs</a></br>
**Depends On:** <a href="vpc/">vpc</a> && <a href="efs">efs</a></br>

## Lambda Echo Server

<a href="lambda-echo/">lambda-echo</a>

## Lambda Echo Server with Custom RestAPI

<a href="lambda-echo-custom-api/">lambda-echo-custom-api</a>
