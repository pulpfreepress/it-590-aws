#!/bin/bash


# Globals
declare -r CLOUDFORMATION_DIR="cloudformation/"
declare -r VPC_DF_TEMPLATE_FILE="vpc.yml"
declare -r REGION_VIRGINIA="us-east-1"
declare -r REGION_OHIO="us-east-2"

declare _deployment_region=${REGION_VIRGINIA}





deploy_vpc() {
    echo "Deploying VPC"
    aws --region ${_deployment_region} cloudformation deploy \
        --template-file $CLOUDFORMATION_DIR$VPC_DF_TEMPLATE_FILE \
        --stack-name vpc-stack \
        --capabilities CAPABILITY_IAM \
        --debug
}


display_usage() {
    echo
    echo "-----------------------------------------------------------------------"
    echo " Usage: `basename $0` []va | oh] vpc "
    echo "                                   "
    echo " Example: ./build.sh va vpc       # Deploy the VPC in region US-EAST-1"
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
        vpc)
            deploy_vpc
            ;;

        *)
            display_usage

    esac
}


validate_template(){
    echo "Validating CF Template: " $CLOUDFORMATION_DIR$VPC_DF_TEMPLATE_FILE
    aws cloudformation validate-template --template-body file://$CLOUDFORMATION_DIR$INFRASTRUCTURE_DIR$VPC_DF_TEMPLATE_FILE
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
