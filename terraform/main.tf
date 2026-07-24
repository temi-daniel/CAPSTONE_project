# VPC AND SUBNET CONFIGURATION
resource "aws_vpc" "execute" {
    cidr_block = var.vpc_cidr
    enable_dns_support = var.vpc_enable_dns_support
    enable_dns_hostnames = var.vpc_enable_dns_hostnames

    tags = {
        name = "${var.project_name}-vpc"
        environment = var.vpc_environment
    }
}
resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.public_subnet1_cidr
    availability_zone = var.az1


    tags = {
        name = "${var.project_name}-public-subnet-1"
        environment = var.vpc_environment
    }
}

resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.public_subnet2_cidr
    availability_zone = var.az2

    tags = {
        name = "${var.project_name}-public-subnet-2"
        environment = var.vpc_environment
    }
}

resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.private_subnet1_cidr
    availability_zone = var.az1

    tags = {
        name = "${var.project_name}-private-subnet-1"
        environment = var.vpc_environment
    }
}
resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.private_subnet2_cidr
    availability_zone = var.az2

    tags = {
        name = "${var.project_name}-private-subnet-2"
        environment = var.vpc_environment
    }
}

# ECR CONFIGURATION

resource "aws_ecr" "execute" {

}
