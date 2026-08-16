# aws region variable

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "project-app"
}

# eks variable

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "execute-eks"
}

variable "eks_cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.36"
}

variable "vpc_id" {
  description = "VPC ID from website"
  type        = string
  default = "vpc-006413f21ad661fc7"
}

variable "rds_security_group_id" {
  description = "Security group ID attached to the website RDS instance"
  type        = string
  default = "sg-063154426738ffcf7"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs from Project 1"
  type = list(string)
  default = ["subnet-0a78b85dd36041661", "subnet-061d2a0549d64f13c"]
}

variable "public_subnet_ids" {
  description = "public subnet IDs from Project 1"
  type = list(string)
  default = ["subnet-0bb1e8159f6a23b22", "subnet-05ab5390b22bc49ae"]
}

variable "node_instance_type" {
  description = "EKS worker node instance type"
  type        = string
  default     = "t3.small"
}

variable "node_desired_size" {
  description = "Desired number of EKS nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of EKS nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of EKS nodes"
  type        = number
  default     = 2
}


