# EC2 Web Server Example

This AWS CloudFormation example deploys a Linux server into a public subnet in the custom (non-default) VPC created with the vpc example. It uses the EC2 UserData section to add bash shell instance initialization commands to install Apache and PHP.

## Deploying
From the command line run `./build.sh dev oh ec2` to deploy the ec2 dev stack into us-east-2. When the deployment script successfully completes, run `aws cloudformation list-exports` to list all stack exports. You output should be similar to, but not exactly as the following:

<img src="diagrams/AWSExports.png"></img>

## Ping the Instance
Search the list of exports for **dev-ec2-stack-LinuxServerOnePublicDNS** or **dev-ec2-stack-LinuxServerOnePublicIP** and copy the Value. In your terminal enter:
`ping ec2-3-137-222-192.us-east-2.compute.amazonaws.com` or `ping 3.137.222.192` You should see responses from the server as shown below:

<img src="diagrams/PingInstance.png"></img>

## Test Web Server
Open a browser and either enter the full server DNS or IP address. You should see the Apache Test page.

<img src="diagrams/ApacheTestPage.png"></img>

## PHP Info Page

Add `/phpinfo.php` to the web page URL to access the PHP Info Page:

<img src="diagrams/PHPInfoPage.png"></img>
