#!/bin/bash

declare -r DB_USER_NAME="admin"
declare -r REGION_VIRGINIA="us-east-1"


declare _db_password=$(aws --region ${REGION_VIRGINIA} secretsmanager get-secret-value --secret-id ${DB_PASSWORD_SECRET_NAME} | jq -r '.SecretString' | jq -r '.db_password')

echo "Connecting to database..."
mysql -h dmltht1yel44qq.c3ytpjg6w8pu.us-east-2.rds.amazonaws.com -P 3306 -u${DB_USER_NAME} -p${_db_password} < create_tables.sql
