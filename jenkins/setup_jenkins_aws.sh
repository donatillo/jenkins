#!/bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Update packages"
yum update -y

echo "Add swap"
dd if=/dev/zero of=/swapfile bs=1G count=4
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

echo "Install Java"
yum remove -y java
yum install -y java-1.8.0-openjdk

echo "Install Jenkins stable release"
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
chkconfig jenkins on

echo "Install git"
yum install -y git

echo "Install Docker engine"
yum install docker -y
usermod -aG docker ec2-user
usermod -aG docker jenkins
service docker start
chkconfig docker on

echo "Configure Jenkins"
echo 'JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"' >> /etc/sysconfig/jenkins

echo "Start Jenkins"
service jenkins start
sleep 20

echo "Install plugins & configure"
wget http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin Git
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin workflow-aggregator
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin pipeline-multibranch-defaults
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin terraform
service jenkins restart
sleep 20
java -jar jenkins-cli.jar -s http://localhost:8080/ create-job backend < /tmp/backend.xml 
java -jar jenkins-cli.jar -s http://localhost:8080/ create-job frontend < /tmp/frontend.xml 
sleep 5

echo "Configure jenkins security"
service jenkins stop
echo 'JENKINS_ARGS="--argumentsRealm.passwd.admin=JENKINS_PASSWORD --argumentsRealm.roles.admin=admin"' >> /etc/sysconfig/jenkins
echo 'AWS_DEFAULT_REGION=us-east-1' >> /etc/sysconfig/jenkins
echo 'AWS_ACCESS_KEY_ID="MY_KEY_ID"' >> /etc/sysconfig/jenkins
echo 'AWS_SECRET_ACCESS_KEY="MY_SECRET_KEY"' >> /etc/sysconfig/jenkins
cp /tmp/config.xml /var/lib/jenkins/
service jenkins start
