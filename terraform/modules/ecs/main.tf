resource "aws_ecs_cluster" "this" {
  name = var.project_name
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "wordpresscontainer"
      image     = "wordpress:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
  memory             = "512"
  cpu                = "256"
  execution_role_arn = aws_iam_role.ecs.arn
}

resource "aws_ecs_service" "wordpress" {
  name            = var.project_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnet_private_ids
    security_groups = [aws_security_group.wordpress.id]
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
