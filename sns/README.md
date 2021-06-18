# Simple Notifiction Service (SNS) Stack Example

Deploys an SNS topic and subscription to that topic with an email endpoint.

## Dependencies:

NONE -- The SNS topic deploys in a region's default VPC

## Preliminaries

Prior to deployment, you need to do the following:
-  Edit the build.sh and provide a valid email for the DEFAULT_SUBSCRIPTION_EMAIL constant.
- Optionally, edit the sns.yaml file and do the same for the SubscriptionEmailParameter default value.

## Deployment

Run the build.sh script. Example: `./build.sh dev oh sns` deploys a dev stack into us-east-2.

IMPORTANT: You will receive an email notification to acknowledge the topic subscription. This notification is sent to the subscription email address you provided in the Preliminaries section above.

## Next Steps

Deploy the <a href="../lambda-echo-sns">lambda-echo-sns</a> and send message via the URL. You should receive message notifications at the email address you provided.
