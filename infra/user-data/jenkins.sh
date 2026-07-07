#!/bin/bash
set -e

apt-get update -y

apt-get install -y \
  openjdk-21-jdk \
  git \
  unzip \
  curl \
  wget \
  docker.io

systemctl enable docker
systemctl start docker

mkdir -p /usr/share/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins

usermod -aG docker jenkins
usermod -aG docker ubuntu

systemctl enable jenkins
systemctl start jenkins

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install