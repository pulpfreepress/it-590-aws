# Simple Queueing Service (SQS)

SQS is a managed service that accepts and temporarily stores messages for later retrieval. Client applications can either push messages to a queue or read messages from a queue. Queues enable you to decouple architectural layers so that a casualty to one application layer will have minimal to no impact on other application layers. SQS integrates seamlessly with may other AWS services and form the foundation of what's referred to as Event-Driven Architectures.

This project defines the SQS queue in a CloudFormation template and supplies a bash build.sh for deployment via the command line.

Example: `./build.sh dev oh sqs` --> Deploys an SQS queue in the dev environment in us-east-2.

After successful installation, run `aws cloudformation list-exports` to retrieve the names of the importable services.
