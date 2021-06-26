#!/bin/bash


# Globals
declare -r CLOUDFORMATION_DIR="cloudformation"
declare -r RDS_CF_TEMPLATE_FILE="rds.yaml"
declare -r REGION_VIRGINIA="us-east-1"
declare -r REGION_OHIO="us-east-2"
declare -r STACK_NAME="rds-stack"
declare -r VPC_STACK_NAME="vpc-stack"
declare -r POC_NAME="Your Name"
declare -r DEPLOYMENT_ENVIRONMENT="dev"
declare -r DB_PASSWORD_SECRET_NAME="db_password"
declare -r DB_NAME="database"
declare -r DB_INSTANCE_CLASS="db.t2.micro"
declare -r DB_USER_NAME="admin"



declare _deployment_region=${REGION_VIRGINIA}
declare _deployment_environment=${DEPLOYMENT_ENVIRONMENT}

# This line depends on the utility jq which is a sed-like JSON extraction tool
declare _db_password=$(aws --region ${REGION_VIRGINIA} secretsmanager get-secret-value --secret-id ${DB_PASSWORD_SECRET_NAME} | jq -r '.SecretString' | jq -r '.db_password')


deploy_rds() {
    echo "Deploying RDS stack"
    aws --region ${_deployment_region} cloudformation deploy \
        --template-file ${CLOUDFORMATION_DIR}/${RDS_CF_TEMPLATE_FILE} \
        --stack-name ${_deployment_environment}-${STACK_NAME} \
        --capabilities CAPABILITY_IAM \
        --parameter-overrides "POCNameParameter=${POC_NAME}" \
                              "EnvironmentParameter=${_deployment_environment}" \
                              "DBNameParameter=${_deployment_environment}_${DB_NAME}" \
                              "DBInstanceClassParameter=${DB_INSTANCE_CLASS}" \
                              "DBUsernameParameter=${DB_USER_NAME}" \
                              "DBPasswordParameter=${_db_password}" \
                              "VpcStackNameParameter=${_deployment_environment}-${VPC_STACK_NAME}" \
        --debug
}


display_usage() {
    echo
    echo "-----------------------------------------------------------------------"
    echo " Usage: `basename $0` [dev | test | prod] [va | oh] rds "
    echo "                                   "
    echo " Example: ./build.sh test va rds       # Deploy test environment RDS instance in us-east-1"
    echo
    echo " DB Password: " ${_db_password}
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
        rds)
            deploy_rds
            ;;

        *)
            display_usage

    esac
}


validate_template(){
    echo "Validating CF Template: " $CLOUDFORMATION_DIR$EC2_CF_TEMPLATE_FILE
    aws cloudformation validate-template --template-body file://$CLOUDFORMATION_DIR$EFS_CF_TEMPLATE_FILE
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
