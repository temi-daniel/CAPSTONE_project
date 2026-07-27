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
variable internet_gateway_id {
    type = string
    default = "igw"
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
