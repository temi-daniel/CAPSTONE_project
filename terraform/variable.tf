# aws region variable

variable "aws_region" {
  description = "The region of my deployment"
  type        = string
  default     = "eu-north-1"
}

# vpc variable

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "execute-tech-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "The availability zones to use for the subnets"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "enable_nat_gateway" {
  description = "Whether to enable a NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "internet_gateway_name" {
  description = "The name of the Internet Gateway"
  type        = string
  default     = "execute-tech-igw"
}

variable "public_route_table_name" {
  description = "The name of the public route table"
  type        = string
  default     = "execute-tech-route-table"
}

variable "common_tags" {
  description = "A map of common tags to assign to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "execute-tech"
  }
}

# ecr variables

variable "ecr_repository_website_name" {
  description = "The name of my ECR repo"
  type        = string
  default     = "execute-website-repo"
}

variable "ecr_repository_project_name" {
  description = "The name of the ECR repository for the project"
  type        = string
  default     = "execute-project-repo"
}

variable "ecr_image_tag_mutability" {
  description = "Whether to allow image tag mutation in ECR"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Whether to enable image scanning on push in ECR"
  type        = bool
  default     = true
}

variable "ecr_encryption_type" {
  description = "The type of encryption to use for ECR"
  type        = string
  default     = "AES256"
}

variable "ecr_force_delete" {
  description = "Whether to force delete the ECR repository"
  type        = bool
  default     = false
}

# ecs configuration

variable "ecs_cluster_name" {
  description = "name of my ecs cluster"
  type        = string
  default     = "execute-cluster"
}

# task definition variables

variable "website_task_definition_family" {
  description = "name of my task def"
  type        = string
  default     = "execute-website-task"
}

variable "project_task_definition_family" {
  description = "name of my task def"
  type        = string
  default     = "execute-project-task"
}

variable "task_cpu" {
  description = "cpu for my fargate"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "memory for my fargate"
  type        = string
  default     = "512"
}

variable "website_container_name" {
  description = "name of the website container in the task definition"
  type        = string
  default     = "execute-website-container"
}

variable "project_container_name" {
  description = "name of the project container in the task definition"
  type        = string
  default     = "execute-project-container"
}

variable "container_port" {
  description = "my container port"
  type        = number
  default     = 80
}

variable "website_service_name" {
  description = "ECS service for website"
  type        = string
  default     = "execute-website-service"
}

variable "project_service_name" {
  description = "ECS service for project"
  type        = string
  default     = "execute-project-service"
}

variable "website_container_image" {
  description = "Image tag for the website container. CI/CD registers new task def revisions with the real git-SHA tag on every deploy; this default is only used before any image has been pushed."
  type        = string
  default     = "latest"
}

variable "project_container_image" {
  description = "Image tag for the project container. CI/CD registers new task def revisions with the real git-SHA tag on every deploy; this default is only used before any image has been pushed."
  type        = string
  default     = "latest"
}

variable "desired_count" {
  description = "the service desired count"
  type        = number
  default     = 2
}

variable "ecs_security_group" {
  description = "security group for my ecs"
  type        = string
  default     = "execute-ecs-sg"
}

variable "assign_public_ip" {
  description = "public ip"
  type        = bool
  default     = false
}

variable "min_healthy_percent" {
  description = "minimum percentage of my desired count"
  type        = number
  default     = 100
}

variable "max_healthy_percent" {
  description = "maximum percentage of my desired count"
  type        = number
  default     = 200
}

variable "health_check_grace_period_seconds" {
  description = "time to make task boot up"
  type        = number
  default     = 60
}

variable "enable_ecs_exec" {
  description = "Whether ECS Exec (aws ecs execute-command) is enabled on the service, allowing a shell session into running containers"
  type        = bool
  default     = true
}

# application load balancer variable

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "execute-alb"
}

variable "website_target_group" {
  description = "Name of website ALB target group"
  type        = string
  default     = "execute-website-tg"
}

variable "project_target_group" {
  description = "Name of project ALB target group"
  type        = string
  default     = "execute-project-tg"
}

variable "alb_security_group" {
  description = "Security group of ALB"
  type        = string
  default     = "execute-alb-sg"
}

variable "alb_listener_port" {
  description = "port exposed to my ALB"
  type        = number
  default     = 80
}

variable "alb_health_check_path" {
  description = "ecs health check path"
  type        = string
  default     = "/"
}

variable "alb_health_check_interval" {
  description = "seconds between health checks"
  type        = number
  default     = 30
}

variable "alb_health_check_timeout" {
  description = "seconds to wait for health check response"
  type        = number
  default     = 5
}

variable "alb_health_check_healthy_threshold" {
  description = "consecutive passing checks needed to mark a target healthy"
  type        = number
  default     = 3
}

variable "alb_health_check_unhealthy_threshold" {
  description = "consecutive failing checks needed to mark a target unhealthy"
  type        = number
  default     = 3
}

variable "website_container_port" {
  description = "Container port for the website"
  type        = number
  default     = 80
}

variable "project_container_port" {
  description = "Container port for the project"
  type        = number
  default     = 80
}

variable "project_listener_rule_priority" {
  description = "Priority of the listener rule routing to the project app (lower = evaluated first, must be unique per listener)"
  type        = number
  default     = 100
}

variable "project_path_pattern" {
  description = "URL path pattern that routes traffic to the project target group"
  type        = list(string)
  default     = ["/project/*"]
}

# rds variables

variable "db_identifier" {
  description = "Name of RDS instance in AWS"
  type        = string
  default     = "capstone-db"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "executedb"
}

variable "db_engine_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "16"
}

variable "db_instance_class" {
  description = "instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "storage size"
  type        = number
  default     = 20
}

variable "db_master_username" {
  description = "master db username - password is generated separately, never written to a .tf file"
  type        = string
  default     = "dbadmin"
}

variable "db_backup_retention_days" {
  description = "backup retention window"
  type        = number
  default     = 7
}

variable "db_multi_az" {
  description = "whether a standby replica runs in a second AZ"
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "blocks accidental delete"
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "skip final snapshot on deletion"
  type        = bool
  default     = true
}

variable "db_security_group" {
  description = "security group for rds"
  type        = string
  default     = "execute-db-sg"
}

# cloudwatch logs

variable "website_log_group_name" {
  description = "CloudWatch log group for the website task"
  type        = string
  default     = "/ecs/execute-website-task"
}

variable "project_log_group_name" {
  description = "CloudWatch log group for the project task"
  type        = string
  default     = "/ecs/execute-project-task"
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 14
}

# iam variable

variable "task_execution_role_name" {
  description = "task definition execution role"
  type        = string
  default     = "execute-ecs-task-execution-role"
}

variable "task_role_name" {
  description = "task definition role"
  type        = string
  default     = "execute-ecs-task-role"
}

# secrets manager variable

variable "db_secrets_name" {
  description = "secrets manager storing rds master credentials"
  type        = string
  default     = "execute/rds/master-credentials"
}
