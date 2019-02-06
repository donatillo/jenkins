#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 ACCESS_KEY SECRET_KEY"
    exit 1
fi

touch jenkins_aws.pub jenkins_aws.pem
terraform destroy -var "access_key=$1" -var "secret_key=$2"
rm -f jenkins_aws.pub jenkins_aws.pem
