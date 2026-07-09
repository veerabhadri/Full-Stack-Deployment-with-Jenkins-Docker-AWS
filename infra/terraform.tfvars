##############################################
# AWS Configuration
##############################################

aws_region  = "us-east-1"
environment = "production"

project_name = "full-stack-deployment"

##############################################
# Networking
##############################################

vpc_cidr = "10.0.0.0/16"

public_subnet_a_cidr = "10.0.1.0/24"
public_subnet_b_cidr = "10.0.2.0/24"

private_subnet_a_cidr = "10.0.3.0/24"
private_subnet_b_cidr = "10.0.4.0/24"

##############################################
# Jenkins EC2
##############################################

key_name = "ikundji"

jenkins_instance_type = "t3.small"
jenkins_volume_size   = 30

##############################################
# Amazon ECR
##############################################

frontend_repository_name = "full-stack-deployment-frontend"
backend_repository_name  = "full-stack-deployment-backend"

##############################################
# Amazon ECS
##############################################

frontend_cpu    = 256
frontend_memory = 512

backend_cpu    = 256
backend_memory = 1024

ecs_desired_count = 1

##############################################
# Application Load Balancer
##############################################

alb_idle_timeout = 60