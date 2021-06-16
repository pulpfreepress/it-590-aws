#!/bin/bash


# Globals
declare -r CLOUDFORMATION_DIR="cloudformation"
declare -r EFS_CF_TEMPLATE_FILE="efs.yaml"
declare -r REGION_VIRGINIA="us-east-1"
declare -r REGION_OHIO="us-east-2"
declare -r STACK_NAME="efs-stack"
declare -r DEPLOYMENT_ENVIRONMENT="dev"
declare -r VPC_STACK_NAME="vpc-stack"

declare _deployment_region=${REGION_VIRGINIA}
declare _deployment_environment=${DEPLOYMENT_ENVIRONMENT}





deploy_efs() {
    echo "Deploying EFS stack"
    aws --region ${_deployment_region} cloudformation deploy \
        --template-file ${CLOUDFORMATION_DIR}/${EFS_CF_TEMPLATE_FILE} \
        --stack-name ${_deployment_environment}-${STACK_NAME} \
        --capabilities CAPABILITY_NAMED_IAM \
        --parameter-overrides "OwnerParameter=Your Name" \
                              "VpcStackNameParameter=${_deployment_environment}-${VPC_STACK_NAME}" \
                              "EnvironmentParameter=${_deployment_environment}" \
        --debug
}


display_usage() {
    echo
    echo "-----------------------------------------------------------------------"
    echo " Usage: `basename $0` [dev | test | prod] [va | oh] efs "
    echo "                                   "
    echo " Example: ./build.sh test va efs       # Deploy test environment EFS shares in us-east-1"
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


deploy_cloudformation_script() {
    case $1 in
        efs)
            deploy_efs
            ;;

        *)
            display_usage

    esac
}


validate_template(){
    echo "Validating CF Template: " ${CLOUDFORMATION_DIR}/${EFS_CF_TEMPLATE_FILE}
    aws cloudformation validate-template --template-body file://${CLOUDFORMATION_DIR}/${EFS_CF_TEMPLATE_FILE}
}


process_arguments() {

    #process first argument
    set_environment $1; shift

    #process second argument
    set_region $1; shift

    #process third argument
    deploy_cloudformation_script $1
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
