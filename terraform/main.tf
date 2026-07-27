# VPC AND SUBNET CONFIGURATION
resource "aws_vpc" "execute" {
    cidr_block = var.vpc_cidr
    enable_dns_support = var.vpc_enable_dns_support
    enable_dns_hostnames = var.vpc_enable_dns_hostnames

    tags = {
        Name = "${var.project_name}-vpc"
        Environment = var.vpc_environment
    }
}
resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.public_subnet1_cidr
    availability_zone = var.az1


    tags = {
        Name = "${var.project_name}-public-subnet-1"
        Environment = var.vpc_environment
    }
}

resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.public_subnet2_cidr
    availability_zone = var.az2

    tags = {
        Name = "${var.project_name}-public-subnet-2"
        Environment = var.vpc_environment
    }
}

resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.private_subnet1_cidr
    availability_zone = var.az1

    tags = {
        Name = "${var.project_name}-private-subnet-1"
        Environment = var.vpc_environment
    }
}
resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.private_subnet2_cidr
    availability_zone = var.az2

    tags = {
        Name = "${var.project_name}-private-subnet-2"
        Environment = var.vpc_environment
    }
}

# ECR CONFIGURATION

resource "aws_ecr_repository" "website" {
    name = var.website_ecr_repository
    image_tag_mutability = var.ecr_image_tag_mutability

    image_scanning_configuration {
      scan_on_push = var.ecr_image_scanning
    }
    encryption_configuration {
      encryption_type = var.ecr_encryption_settings
    }

    tags = {
        Name = "${var.project_name}-website_repo"
        Environment = var.ecr_environment
    }
}

resource "aws_ecr_repository" "project" {
    name = var.project_ecr_repository
    image_tag_mutability = var.ecr_image_tag_mutability

    image_scanning_configuration {
      scan_on_push = var.ecr_image_scanning
    }

    encryption_configuration {
      encryption_type = var.ecr_encryption_settings
    }

    tags = {
        Name = "${var.project_name}-project_repo"
        Environment = var.ecr_environment
    }
}

# ECS CONFIGURATION
