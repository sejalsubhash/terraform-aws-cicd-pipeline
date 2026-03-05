#!/bin/bash
yum update -y

# Install Docker
yum install docker -y
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

# Install Ruby (Required for CodeDeploy)
yum install ruby -y
yum install wget -y

cd /home/ec2-user

# Install CodeDeploy Agent
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
./install auto

service codedeploy-agent start
chkconfig codedeploy-agent on