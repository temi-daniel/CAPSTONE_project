# vpc variable

resource "aws_vpc" "admin" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.admin.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.vpc_name}-public-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.admin.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.vpc_name}-private-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.admin.id

    tags = {
        Name = var.internet_gateway_name
    }
}

resource "aws_route_table" "publicRT" {
    vpc_id = aws_vpc.admin.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "publicRTassociation" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.publicRT.id

}
# ECR CONFIGURATION

resource "aws_ecr_repository" "website" {
    name = var.ecr_repository_website_name
    image_tag_mutability = var.ecr_image_tag_mutability
    force_delete = var.ecr_force_delete

    image_scanning_configuration {
        scan_on_push = var.ecr_scan_on_push
    }

    encryption_configuration {
      encryption_type = var.ecr_encryption_type
    }

    tags = merge(
        var.common_tags,
        {
            Name = var.ecr_repository_website_name
        }
    )

}

resource "aws_ecr_repository" "project" {
    name = var.ecr_repository_project_name
    image_tag_mutability = var.ecr_image_tag_mutability
    force_delete = var.ecr_force_delete

    encryption_configuration {
      encryption_type = var.ecr_encryption_type
    }


    image_scanning_configuration {
        scan_on_push = var.ecr_scan_on_push
    }

   tags = merge(
        var.common_tags,
        {
            Name = var.ecr_repository_website_name
        }
    )

}

# ecs resource

resource "aws_ecs_cluster" "execute" {
    name = var.ecs_cluster_name

    setting {
        name = "containerInsights"
        value = "enabled"
    }

    tags = merge(
        var.common_tags,
        {
            Name = var.ecs_cluster_name
        }
    )
}

resource "aws_task_definition_family" "website" {
    name = var.website_task_definition_family
    task_cpu = var.task_cpu
    task_memory = var.task_memory
    requires_compatibilities = ["FARGATE"]
    execution_role_arn = ""
    task_role_arn = ""

    container_definitions = jsonencode([
        {
            name = var.website_container_name
            image = "${aws_ecr_repository.website.repository_url}:latest"

            portMappings = [
                {
                    containerPort = var.container_port
                    protocol = "tcp"
                }
            ]
        }
    ])
}

resource "aws_task_definition_family" "project" {
    name = var.project_task_definition_family
    task_cpu = var.task_cpu
    task_memory = var.task_memory
    requires_compatibilities = ["FARGATE"]
    execution_role_arn = ""
    task_role_arn = ""

    container_definitions = jsonencode([
        {
            name = var.project_container_image
            image = "${aws_ecr_repository.project.repository_url}:latest"

            portMappings = [
                {
                    containerPort = var.container_port
                    protocol = "tcp"
                }
            ]

            secrets = [
        {
          name      = "DB_USERNAME"
          valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:username::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:password::"
        },
        {
          name      = "DB_HOST"
          valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:host::"
        },
        {
          name      = "DB_NAME"
          valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:dbname::"
        }
      ]


        }
    ])

}

resource "aws_ecs_service" "website" {
    name = var.website_service_name
    cluster = var.ecs_cluster_name
    task_definition = var.website_task_definition_family
    desired_count = var.desired_count
    launch_type = "FARGATE"
    enable_execute_command = true

    deployment_minimum_healthy_percent = var.min_healthy_percent
    deployment_maximum_percent = var.min_healthy_percent
    health_check_grace_period_seconds = var.health_check_grace_period_seconds

    network_configuration {
        subnets = aws_subnet.private[1].id
        security_groups = [aws_security_group.ecs.id]
        assign_public_ip = false

    }

    load_balancer {
      target_group_arn = aws_lb_target_group.website.arn
      container_name = var.website_container_name
      container_port = var.website_container_port
    }

    depends_on = [ aws_lb_listener.http ]


}

resource "aws_ecs_service" "project" {
    name = var.project_service_name
    cluster = var.ecs_cluster_name
    task_definition = var.project_task_definition_family
    desired_count = var.desired_count
    launch_type = "FARGATE"
    enable_execute_command = true

    deployment_minimum_healthy_percent = var.min_healthy_percent
    deployment_maximum_percent = var.max_healthy_percent
    health_check_grace_period_seconds = var.health_check_grace_period_seconds

    network_configuration {
        subnets = aws_subnet.private[*].id
        security_groups = [aws_security_group.ecs.id]
        assign_public_ip = false

    }

    load_balancer {
      target_group_arn = aws_lb_target_group.project.arn
      container_name = var.project_container_name
      container_port = var.project_container_port
    }

    depends_on = [aws_lb_listener.http, aws_lb_listener_rule.project]
}

resource "aws_security_group" "ecs" {
    name = var.ecs_security_group
    vpc_id = aws_vpc.admin.id

    ingress {
        description = "Allow inbound traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [ aws_security_group.alb.id ]
    }

    egress {
        description = "Allow outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = [ aws_security_group.alb ]
    }

    tags = {
      Name = var_ecs_security_group
    }

}

# alb variable

resource "aws_lb" "execute" {
    name = var.alb_name
    internal = false
    load_balancer_type = "application"

    security_groups = [aws_security_group.alb.id]

    subnets = aws_subnet.public[1].id

    tags = {
        Name = var.alb_name
    }
}

resource "aws_security_group" "alb" {
    name = var.alb_security_group
    vpc_id = aws_vpc.admin.id


    ingress {
        description = "Allow inbound traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    ingress {
        description = "allow inbound traffic"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.alb_security_group
    }

}

resource "aws_lb_target_group" "website" {
    name = var.website_target_group
    port = var.website_container_port
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.admin.id

    health_check {
        enabled = true
        path = var.alb_health_check_path
        protocol = "HTTP"
        port = "traffic-port"

        interval = var.alb_health_check_interval
        timeout = var.alb_health_check_timeout
        healthy_threshold = var.alb_health_check_healthy_threshold


    }
}

resource "aws_lb_target_group" "project" {
    name = var.project_target_group
    port = var.project_container_port
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.admin.id

    health_check {
        enabled = true
        path = var.alb_health_check_path
        protocol = "HTTP"
        port = "traffic-port"

        interval = var.alb_health_check_interval
        timeout = var.alb_health_check_timeout
        healthy_threshold = var.alb_health_check_healthy_threshold

    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.execute.arn

    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.website.arn
    }

}

resource "aws_listener_rule" "project" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    action {
        type = "forward"
        target_group = aws_lb_target_group.project.arn
    }

    condition {
        path_pattern {
            values = ["/project", "/project"]
        }
    }
}

# rds resource

resource "aws_db_subnet_group" "main" {
    name = "${var.db_identifier}-subnet-group"
    subnet_ids = aws_subnet.private[1].id

    tags = merge(var.common_tags, { Name = "${var.db_identifier}-subnet-group" })

}

resource "aws_db_instance" "execute" {
    identifier = var.db_identifier
    engine = "postgres"
    engine_version = var.db_engine_version
    instance_class = var.db_instance_class

    allocated_storage = var.db_allocated_storage
    storage_encrypted = true

    db_name = var.db_name
    username = var.db_master_username
    password = random_password.db_master.result

    db_subnet_group_name = aws_db_subnet_group.main.name
    vpc_security_group_ids = [aws_security_group.rds.id]
    publicly_accessible = false

    multi_az = var.db_multi.az
    backup_retention_period = var.db_backup_retention_days
    deletion_protection = var.db_deletion_protection
    skip_final_snapshot = var.db_skip_final_snapshot

    tags = merge(var.common_tags, { Name = var.db_identifier })
}

resource "aws_security_group" "rds" {
    name = var.db_security_group
    vpc_id = aws_vpc.admin.id

    ingress {
        description = "from ecs tasks"
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [aws_security_group.ecs.id]
    }

    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# iam resoure

# Task Execution Role
# Used by ECS agent to pull image from ECR, write logs,
# and resolve secrets referenced in the task definition.

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = var.task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = var.common_tags
}

# Base AWS-managed policy: ECR pull + CloudWatch logs
resource "aws_iam_role_policy_attachment" "ecs_task_execution_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Scoped permission to read only the DB secret (needed to resolve
# the "secrets" block in the container definition)
data "aws_iam_policy_document" "ecs_task_execution_secrets" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.db_credentials.arn]
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_secrets" {
  name   = "read-db-secret"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.ecs_task_execution_secrets.json
}

# ---------------------------------------------------
# Task Role
# Assumed by the running application itself (not the agent).
# Scoped to only what the app needs at runtime. Empty/minimal
# by default - extend with statements as the app requires
# specific AWS API access (e.g. S3, SES).
# ---------------------------------------------------

resource "aws_iam_role" "ecs_task" {
  name               = var.task_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = var.common_tags
}

# secrets manager resource

resource "random_password" "db_master" {
    length = 20
    special = true
    override_special = "!#$:>?%&+-="

}

resource "aws_secretsmanager_secret" "db_credentials" {
    name = var.db_secrets_name
    description = "rds postgresql master credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
    secret_id = aws.secretsmanager_secret.db_credentials.id

    secret_string = jsonencode({
        username = var.db_master_username
        password = random_password_db_master.result
        engine = "postgres"
        host = aws_db_instance.main.address
        port = 5432
        dbname = var.db_name

    })

}






