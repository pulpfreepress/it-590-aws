#!/bin/bash


# Globals
declare -r CLOUDFORMATION_DIR="cloudformation/"
declare -r EC2_CF_TEMPLATE_FILE="ec2.yml"
declare -r REGION_VIRGINIA="us-east-1"
declare -r REGION_OHIO="us-east-2"
declare -r STACK_NAME="ec2-stack"

declare _deployment_region=${REGION_VIRGINIA}





deploy_ec2() {
    echo "Deploying EC2 instances..."
    aws --region ${_deployment_region} cloudformation deploy \
        --template-file $CLOUDFORMATION_DIR$EC2_CF_TEMPLATE_FILE \
        --stack-name $STACK_NAME \
        --capabilities CAPABILITY_IAM \
        --parameter-overrides "Owner=Your Name" \
        --debug
}


display_usage() {
    echo
    echo "-----------------------------------------------------------------------"
    echo " Usage: `basename $0` [va | oh] ec2 "
    echo "                                   "
    echo " Example: ./build.sh va ec2       # Deploy ec2 instances in region US-EAST-1"
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
    set_region $1; shift

    #process second argument
    deploy_cloudformation_script $1
}


main() {

    if [ "$#" -ne 2 ]; then
        display_usage
        exit 1
    fi


    process_arguments $1 $2
    print_script_complete

    exit 1

}

main "$@"
