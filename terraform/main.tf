# VPC AND SUBNET CONFIGURATION
resource "aws_vpc" "execute" {
    cidr_block = var.vpc_cidr
    enable_dns_support = var.vpc_enable_dns_support
    enable_dns_hostnames = var.vpc_enable_dns_hostnames
    vpc_security_group_ids = [aws_security_group.execute-sg.id]

    tags = {
        Name = "${var.project_name}-vpc"
        Environment = var.vpc_environment
    }
}
resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.public_subnet1_cidr
    availability_zone = var.az1
    map_ip_on_lauch = true


    tags = {
        Name = "${var.project_name}-public-subnet-1"
        Environment = var.vpc_environment
    }
}

resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.execute.id
    cidr_block = var.public_subnet2_cidr
    availability_zone = var.az2
    map_ip_on_lauch = true

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

# INTERNET GATEWAY

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.execute.id

    tags = {
        Name = "${var.project_name}-igw"
    }
}
# ELASTIC IP

resource "aws_eip" "web" {
    domain = "vpc"

    tags = {
        Name = "${var.project_name}-web-eip"
    }
}

# NAT GATEWAY

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.web.id
    subnet_id = aws_subnet.public[1].id

    depends_on = [aws_internet_gateway.nat]

    tags = {
        Name = "${var.project_name}-nat"
    }
}

# PUBLIC ROUTE TABLE

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.execute.id

    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.project_name}-public-route"
    }
}

# PRIVATE ROUTE TABLE

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.execute.id

    route = {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = {
        Name = "${var.project_name}-public-route"
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

resource "aws_security_group" "execute-sg" {
    name = var.security_group_ecs
    description = "security_group_for_ecs"
    vpc_id = aws_vpc.execute.id
}
# RULE FOR SECURITY GROUP

resource "aws_security_group_rule" "inbound" {
    security_group_id = aws_security_group.execute-sg.id
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
}

resource "aws_security_group_rule" "outbound" {
    security_group_id = aws_security_group.execute-sg.id
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = var.allowed_ssh_cidr_blocks
}
