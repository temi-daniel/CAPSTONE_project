output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.admin.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "website_ecr_repository_url" {
  description = "URL of the website ECR repository"
  value       = aws_ecr_repository.website.repository_url
}

output "project_ecr_repository_url" {
  description = "URL of the project ECR repository"
  value       = aws_ecr_repository.project.repository_url
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = aws_lb.execute.dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.execute.name
}

output "website_service_name" {
  description = "Name of the website ECS service"
  value       = aws_ecs_service.website.name
}

output "project_service_name" {
  description = "Name of the project ECS service"
  value       = aws_ecs_service.project.name
}

output "rds_endpoint" {
  description = "Connection endpoint (host:port) for the RDS instance"
  value       = aws_db_instance.execute.endpoint
  sensitive   = true
}

output "rds_address" {
  description = "Hostname of the RDS instance (no port)"
  value       = aws_db_instance.execute.address
  sensitive   = true
}

output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret holding RDS master credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task.arn
}
