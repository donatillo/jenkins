#!/bin/sh

#
# generate keys
#

if [ ! -f "jenkins_aws.pem" ]; then
    pushd .
    cd ~/.ssh
    yes y | ssh-keygen -t rsa -b 2048 -v -f jenkins_aws -P ""
    popd
    cat ~/.ssh/jenkins_aws.pub > jenkins_aws.pub
    cat ~/.ssh/jenkins_aws     > jenkins_aws.pem
    chmod 400 jenkins_aws.pem
fi

# vim:ts=4:sw=4:sts=4:expandtab
