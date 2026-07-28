# AWS REGION
variable aws_region {
    type = string
    default = "eu-north-1"
}
variable project_name {
    type = string
    default = "execute-tech"
}

# VPC CONFIGURATION
variable vpc_name {
    type = string
    default = "execute-tech-vpc"
}
variable vpc_cidr {
    type = string
    default = "10.0.0.0/16"
}
variable vpc_enable_dns_support {
    type = bool
    default = true
}
variable vpc_enable_dns_hostnames {
    type = bool
    default = true
}
variable vpc_environment {
    type = string
    default = "dev"
}
# AVAILABILITY ZONES
variable az1 {
    type = string
    default = "eu-north-1a"
}
variable az2 {
    type = string
    default = "eu-north-1b"
}

#PUBLIC SUBNETS
variable public_subnet1_cidr {
    type = string
    default = "10.0.1.0/24"
}

variable public_subnet2_cidr {
    type = string
    default = "10.0.2.0/24"
}
#PRIVATE SUBNETS

variable private_subnet1_cidr {
    type = string
    default = "10.0.3.0/24"
}

variable private_subnet2_cidr {
    type = string
    default = "10.0.4.0/24"
}


#ECR CONFIGURATION

variable website_ecr_repository {
    type = string
    default = "execute_tech_website"
}
variable project_ecr_repository {
    type = string
    default = "execute_tech_project"
}
variable ecr_repository_type {
    type = string
    default = "private"
}
variable ecr_image_tag_mutability {
    type = string
    default = "IMMUTABLE"
}
variable ecr_encryption_settings {
    type = string
    default = "AES-256"
}
variable ecr_image_scanning {
    type = bool
    default = true
}
variable ecr_environment {
    type = string
    default = "dev"
}

#ECS CONFIGURATION

variable ecs_cluster_name {
    type = string
    default = "execute-tech-cluster"
}
variable aws_region {
    type = string
    default = "eu-north-1"
}

# TASK DEFINITION

variable task_definition_family {
    type = string
    default = "execute-tech-task"
}
variable task_cpu {
    type = string
    default = "2048"
}
variable task_memory {
    type = string
    default = "4096"
}
variable network_mode {
    type = string
    default = "awsvpc"
}
variable task_role_arn {
    type = string
    default = "ecsTaskExecutionRole"
}
variable task_execution_role_arn {
    type = string 
    default = "ecsTaskExecutionRole"
}
variable requires_compatibilities {
    type = list(string)
    default = ["FARGATE"]
}

# CONTAINER
variable website_container_name {
    type = string
    default = "website-container"
}
variable project_container_name {
    type = string
    default = "project-app-container"
}
variable website_container_image {
    type = string
    default = "818005122467.dkr.ecr.eu-north-1.amazonaws.com/execute_tech_website" 
}
variable website_container_image {
    type = string
    default = "818005122467.dkr.ecr.eu-north-1.amazonaws.com/execute_tech_project"
}
variable website_container_port {
    type = number 
    default = 80
}
variable project_container_port {
    type = number 
    default = 80
}

# ECS SERVICE
variable ecs_service_name {
    type = string
    default = "execute-tech-service"
}
variable desired_count {
    type = number 
    default = 2
}
variable assign_public_ip {
    type = bool
    default = false
}
# NETWORKING

variable security_group_ecs {
    type = string
    default = "execute-tech-sg"
}
variable allowed_ssh_cidr_blocks {
    type = list(string)

    validation {
        condition = !conditions(var.allowed_ssh_cidr_blocks, 0.0.0.0/0)
    }
}

