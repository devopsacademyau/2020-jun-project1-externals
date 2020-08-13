data "aws_ecs_task_definition" "wordpress" {
  task_definition = aws_ecs_task_definition.wordpress.family
  depends_on      = [aws_ecs_task_definition.wordpress]
}

resource "aws_ecs_cluster" "this" {
  name = var.project_name
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.memory
  cpu                      = var.cpu
  execution_role_arn       = aws_iam_role.ecs.arn
  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = "${aws_ecr_repository.wprepo.repository_url}:${var.image_tag}"
      essential = true
      mountPoints = [
        {
          sourceVolume  = "efs-volume"
          containerPath = "/var/www/html"
        }
      ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.ecs.name
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "wp_ecs"
        }
      }
      "environment" : [
        {
          "name" : "WORDPRESS_DB_HOST",
          "value" : var.rds.endpoint
        },
        {
          "name" : "WORDPRESS_DB_USER",
          "value" : var.rds.username
        },
        {
          "name" : "WORDPRESS_DB_PASSWORD",
          "value" : var.rds.password
        },
        {
          "name" : "WORDPRESS_DB_NAME",
          "value" : var.rds.dbname
        }
      ]
    }
  ])

  volume {
    name = "efs-volume"
    efs_volume_configuration {
      file_system_id = var.file_system_id
    }
  }
  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.retention_in_days
}


resource "aws_ecs_service" "wordpress" {
  name                = var.project_name
  cluster             = aws_ecs_cluster.this.id
  desired_count       = var.desired_count
  task_definition = "${aws_ecs_task_definition.wordpress.family}:${max(aws_ecs_task_definition.wordpress.revision, data.aws_ecs_task_definition.wordpress.revision)}"
  launch_type         = "FARGATE"
  platform_version    = var.ecs_platform_version
  scheduling_strategy = "REPLICA"
  force_new_deployment = true
  network_configuration {
    subnets          = var.subnet_private_ids
    security_groups  = [aws_security_group.wordpress.id]
    assign_public_ip = true
  }

   load_balancer {
    target_group_arn = aws_alb_target_group.target_group.arn
    container_port = "80"
    container_name = "wordpress"
  }


}



resource "aws_ecr_repository" "wprepo" {
  name                 = "wordpress"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}



resource "aws_security_group" "wordpress" {

  description = "ECS Security Group"
  vpc_id      = var.vpc_id
  name        = "project1_ext1_ecs_sg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}