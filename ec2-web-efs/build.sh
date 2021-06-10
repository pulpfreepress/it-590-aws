#!/bin/bash


# Globals
declare -r CLOUDFORMATION_DIR="cloudformation/"
declare -r EC2_CF_TEMPLATE_FILE="ec2.yml"
declare -r REGION_VIRGINIA="us-east-1"
declare -r REGION_OHIO="us-east-2"
declare -r STACK_NAME="ec2-stack"
declare -r DEPLOYMENT_ENVIRONMENT="dev"
declare -r VPC_STACK_NAME="vpc-stack"
declare -r EFS_STACK_NAME="efs-stack"

declare _deployment_region=${REGION_VIRGINIA}
declare _deployment_environment=${DEPLOYMENT_ENVIRONMENT}

declare _efs_web_file_share=$(aws cloudformation list-exports --query "Exports [?contains(Name,'${_deployment_environment}-${EFS_STACK_NAME}-WebFileShare')].Value" --output text)



deploy_ec2() {
    echo "Deploying EC2 instances..."
    aws --region ${_deployment_region} cloudformation deploy \
        --template-file $CLOUDFORMATION_DIR$EC2_CF_TEMPLATE_FILE \
        --stack-name $_deployment_environment-$STACK_NAME \
        --capabilities CAPABILITY_NAMED_IAM \
        --parameter-overrides "OwnerParameter=Your Name" \
                              "KeyNameParameter=it-590-ec2-key" \
                              "VpcStackNameParameter=${_deployment_environment}-${VPC_STACK_NAME}" \
                              "EnvironmentParameter=${_deployment_environment}" \
                              "EFSWebFileShareParameter=${_efs_web_file_share}" \
        --debug
}


display_usage() {
    echo
    echo "-----------------------------------------------------------------------"
    echo " Usage: `basename $0` [dev | test | prod] [va | oh] ec2 "
    echo "                                   "
    echo " Example: ./build.sh test va ec2       # Deploy test environment ec2 instances in region US-EAST-1"
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


deploy_cloudformation_script() {
    case $1 in
        ec2)
            validate_template
            deploy_ec2
            ;;

        *)
            display_usage

    esac
}


validate_template(){
    echo "Validating CF Template: " $CLOUDFORMATION_DIR$EC2_CF_TEMPLATE_FILE
    aws cloudformation validate-template --template-body file://$CLOUDFORMATION_DIR$EC2_CF_TEMPLATE_FILE
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
