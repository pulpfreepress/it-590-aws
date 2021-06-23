#!/bin/bash


# Globals
declare -r SAM_TEMPLATE_DIR="sam"
declare -r SAM_TEMPLATE_FILE="lambda-echo-sqs-dynamodb.yaml"
# You will need to use a different deployment bucket Name
# and make sure it exits along with the prefix folder/path
declare -r S3_BUCKET="deployment-it590-us-east-2"
declare -r S3_PREFIX="sam"
# ********************************************************
declare -r BUILD_DIR="build"
declare -r DEPLOYMENT_TEMPLATE_FILE="template.yaml"
declare -r REGION_VIRGINIA="us-east-1"
declare -r REGION_OHIO="us-east-2"
declare -r STACK_NAME="lambda-echo-stack"
declare -r DEPLOYMENT_ENVIRONMENT="dev"
declare -r VPC_STACK_NAME="vpc-stack"
declare -r EFS_STACK_NAME="efs-stack"
declare -r SQS_STACK_NAME="sqs-stack"
declare -r POC_NAME="YourName"
declare -r DEFAULT_SNS_TOPIC_NAME="Echo-Message-Topic"
declare -r DEFAULT_SQS_MESSAGE_QUEUE_NAME="Echo-Message-Queue"
declare -r DYNAMODB_STACK_NAME="dynamodb-stack"


declare _deployment_region=${REGION_VIRGINIA}
declare _deployment_environment=${DEPLOYMENT_ENVIRONMENT}

declare _dynamodb_table_name=$(aws cloudformation list-exports \
        --query "Exports [?contains(Name,'${_deployment_environment}-${DYNAMODB_STACK_NAME}-TableName')].Value" \
        --output text)
declare _sqs_message_queue_name=$(aws cloudformation list-exports \
        --query "Exports [?contains(Name,'${_deployment_environment}-${SQS_STACK_NAME}-${DEFAULT_SQS_MESSAGE_QUEUE_NAME}-Name')].Value" \
        --output text)
declare _sqs_message_queue_arn=$(aws cloudformation list-exports \
        --query "Exports [?contains(Name,'${_deployment_environment}-${SQS_STACK_NAME}-${DEFAULT_SQS_MESSAGE_QUEUE_NAME}-Arn')].Value" \
        --output text)



prep_files() {
  echo "Zipping lambda handler modules for deployment."
  # Remove build dir if exits and all subdirs
  rm -rf ${BUILD_DIR}
  # Create build dir
  mkdir ${BUILD_DIR}
  # Remove echo.zip from sam dir
  rm -f sam/echo.zip
  rm -f sam/process.zip
  rm -f sam/query.zip
  # Create echo.zip in sam dir and add src/echo.py
  # and leave off the src dir name (-j)
  zip -j sam/echo.zip src/echo.py
  zip -j sam/process.zip src/process.py
  zip -j sam/query.zip src/query.py
}


sam_package() {
  echo "Running SAM CLI Package."
  sam package --template ${SAM_TEMPLATE_DIR}/${SAM_TEMPLATE_FILE} \
              --s3-bucket ${S3_BUCKET} \
              --s3-prefix ${S3_PREFIX} \
              --output-template-file ${BUILD_DIR}/${DEPLOYMENT_TEMPLATE_FILE} \
              --region ${_deployment_region} \
              --debug

}


sam_deploy() {
    echo "Running SAM CLI build. Deploying Lambda function with API Gateway..."
    sam deploy --template-file ${BUILD_DIR}/${DEPLOYMENT_TEMPLATE_FILE} \
               --stack-name ${_deployment_environment}-${STACK_NAME} \
               --s3-bucket ${S3_BUCKET} \
               --s3-prefix ${S3_PREFIX} \
               --capabilities CAPABILITY_NAMED_IAM \
               --region ${_deployment_region} \
               --confirm-changeset \
               --parameter-overrides "EnvironmentParameter=${_deployment_environment}" \
                                     "POCNameParameter=${POC_NAME}" \
                                     "SnsTopicNameParameter=${_deployment_environment}-${DEFAULT_SNS_TOPIC_NAME}" \
                                     "DynamoDbTableNameParameter=${_dynamodb_table_name}" \
                                     "SqsMessageQueueNameParameter=${_sqs_message_queue_name}" \
                                     "SqsMessageQueueArnParameter=${_sqs_message_queue_arn}" \
              --force-upload \
              --debug

}


display_usage() {
    echo
    echo "-----------------------------------------------------------------------"
    echo " Usage: `basename $0` [dev | test | prod] [va | oh] [ package | deploy | package-deploy ] "
    echo "                                   "
    echo " Examples: ./build.sh test va package       # Package lambda function(s) and generate template.yaml"
    echo "                                              for test environment in us-east-1 region"
    echo "           ./build.sh test va deploy        # Deploy packaged lambda functions(s)"
    echo
    echo "Message Queue ARN: "${_sqs_message_queue_arn}
    echo "Message Queue Name: "${_sqs_message_queue_name}
    echo "-----------------------------------------------------------------------"
}

print_script_complete() {
    echo
    echo "-------------------------------------------------"
    echo "-             Script Complete                   -"
    echo "-------------------------------------------------"
}


set_region() {
    case $1 in
        va)
            _deployment_region=${REGION_VIRGINIA}
            echo "Deployment Region = " ${_deployment_region}
            ;;

        oh)
            _deployment_region=${REGION_OHIO}
            echo "Deployment Region = " ${_deployment_region}
            ;;


        *)
            echo "Setting region to " ${REGION_VIRGINIA}
            _deployment_region=${REGION_VIRGINIA}
            echo "Deployment Region = " ${_deployment_region}
    esac
}


set_environment() {
  case $1 in
    dev)
      _deployment_environment="dev"
      echo "Deployment Environment = " ${_deployment_environment}
      ;;

    test)
     _deployment_environment="test"
     echo "Deployment Environment = " ${_deployment_environment}
     ;;

    prod)
     _deployment_environment="prod"
     echo "Deployment Environment = " ${_deployment_environment}
     ;;

    *)
     _deployment_environment="dev"
     echo "Deployment Environment = " ${_deployment_environment}
     ;;
  esac

}


deploy_sam_template() {
    case $1 in
        package)
            prep_files
            sam_package
            ;;

        deploy)
            sam_deploy
            ;;

        package-deploy)
            prep_files
            sam_package
            sam_deploy
            ;;


        *)
            display_usage

    esac
}


process_arguments() {

    #process first argument
    set_environment $1; shift

    #process second argument
    set_region $1; shift

    #process third argument
    deploy_sam_template $1
}


main() {

    if [ "$#" -ne 3 ]; then
        display_usage
        exit 1
    fi


    process_arguments $1 $2 $3
    print_script_complete

    exit 1

}

main "$@"
