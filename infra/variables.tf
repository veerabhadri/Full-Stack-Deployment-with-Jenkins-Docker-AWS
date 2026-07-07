variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "Public Subnet A CIDR"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "Public Subnet B CIDR"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "Private Subnet A CIDR"
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "Private Subnet B CIDR"
  type        = string
}

variable "key_name" {
  description = "AWS EC2 Key Pair Name"
  type        = string
}

##############################################
# Amazon ECR
##############################################

variable "frontend_repository_name" {
  description = "Amazon ECR repository for the frontend"
  type        = string
}

variable "backend_repository_name" {
  description = "Amazon ECR repository for the backend"
  type        = string
}

##############################################
# ECS Task Definitions
##############################################

variable "frontend_cpu" {
  description = "CPU units for the frontend task"
  type        = number
}

variable "frontend_memory" {
  description = "Memory (MiB) for the frontend task"
  type        = number
}

variable "backend_cpu" {
  description = "CPU units for the backend task"
  type        = number
}

variable "backend_memory" {
  description = "Memory (MiB) for the backend task"
  type        = number
}

variable "ecs_desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
}

##############################################
# Application Load Balancer
##############################################

variable "health_check_path" {
  description = "ALB Health Check Path"
  type        = string
  default     = "/"
}

variable "alb_idle_timeout" {
  description = "Application Load Balancer idle timeout"
  type        = number
  default     = 60
}

##############################################
# Jenkins
##############################################

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
}

variable "jenkins_volume_size" {
  description = "Root EBS volume size for Jenkins"
  type        = number
}

