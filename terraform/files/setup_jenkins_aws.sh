#!/bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Update packages"
yum update -y

echo "Add swap"
dd if=/dev/zero of=/swapfile bs=1M count=1024
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

echo "Install terraform"
wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
unzip terraform_0.11.11_linux_amd64.zip
mv terraform /usr/bin/

echo "Configure Jenkins"
echo 'JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"' >> /etc/sysconfig/jenkins
echo 'export MY_DOMAIN=MY_AWS_DOMAIN' >> /etc/sysconfig/jenkins
echo 'export MY_MAIN_DOMAIN=MY_MAIN_AWS_DOMAIN' >> /etc/sysconfig/jenkins
echo 'export MY_APP=MY_APP_NAME' >> /etc/sysconfig/jenkins
echo 'export BASENAME=MY_BASENAME' >> /etc/sysconfig/jenkins

echo "Start Jenkins"
service jenkins start
sleep 20

echo "Install plugins & configure"
wget http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin Git
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin github
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin workflow-aggregator
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin pipeline-multibranch-defaults
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin terraform
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin pipeline-aws
service jenkins restart
sleep 20
java -jar jenkins-cli.jar -s http://localhost:8080/ create-job infra < /tmp/infra.xml 
java -jar jenkins-cli.jar -s http://localhost:8080/ create-job backend < /tmp/backend.xml 
java -jar jenkins-cli.jar -s http://localhost:8080/ create-job frontend < /tmp/frontend.xml 
java -jar jenkins-cli.jar -s http://localhost:8080/ create-credentials-by-xml "SystemCredentialsProvider::SystemContextResolver::jenkins" "(global)" < /tmp/awscred.xml
sleep 5

echo "Configure jenkins security"
service jenkins stop
echo 'JENKINS_ARGS="--argumentsRealm.passwd.admin=JENKINS_PASSWORD --argumentsRealm.roles.admin=admin"' >> /etc/sysconfig/jenkins
cp /tmp/config.xml /var/lib/jenkins/
rm /tmp/awscred.xml /tmp/config.xml /tmp/job.xml /tmp/setup_jenkins_aws.sh
service jenkins start
