#!/bin/bash


# Globals
declare -r SAM_TEMPLATE_DIR="sam"
declare -r SAM_TEMPLATE_FILE="lambda-echo.yaml"
declare -r S3_BUCKET="deployment-it590-us-east-2"
declare -r S3_PREFIX="sam"
declare -r BUILD_DIR="build"
declare -r DEPLOYMENT_TEMPLATE_FILE="template.yaml"
declare -r REGION_VIRGINIA="us-east-1"
declare -r REGION_OHIO="us-east-2"
declare -r STACK_NAME="lambda-echo-stack"
declare -r DEPLOYMENT_ENVIRONMENT="dev"
declare -r VPC_STACK_NAME="vpc-stack"
declare -r EFS_STACK_NAME="efs-stack"
declare -r POC_NAME="YourName"

declare _deployment_region=${REGION_VIRGINIA}
declare _deployment_environment=${DEPLOYMENT_ENVIRONMENT}



sam_build() {

  echo "Running SAM CLI Build."
  echo "Locking python requirements...writing requirements.txt."
  pipenv lock -r > echo-lambda/requirements.txt
  # rm -rf .venv
  sam build --base-dir . \
            --build-dir ${BUILD_DIR} \
            --template ${SAM_TEMPLATE_DIR}/${SAM_TEMPLATE_FILE} \
            --region ${_deployment_region} \
            --parameter-overrides "EnvironmentParameter=${_deployment_environment}" "POCNameParameter=${POC_NAME}" \
            --debug

}


sam_package() {
  echo "Running SAM CLI Package."
  rm -rf ${BUILD_DIR}
  mkdir ${BUILD_DIR}
  rm sam/echo.zip
  zip -j sam/echo.zip src/echo.py
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
               --capabilities CAPABILITY_IAM \
               --region ${_deployment_region} \
               --confirm-changeset \
               --parameter-overrides "EnvironmentParameter=${_deployment_environment}" \
                                     "POCNameParameter=${POC_NAME}" \
              --force-upload \
              --debug

}


display_usage() {
    echo
    echo "-----------------------------------------------------------------------"
    echo " Usage: `basename $0` [dev | test | prod] [va | oh] [ build | deploy ] "
    echo "                                   "
    echo " Example: ./build.sh test va build       # Build lambda function and generate template.yaml"
    echo " "
    echo " EFS WebFileShare == ${_efs_web_file_share}"
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
        build)
            sam_build
            ;;

        package)
            sam_package
            ;;

        deploy)
            sam_deploy
            ;;

        deploy)
            sam_build
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
