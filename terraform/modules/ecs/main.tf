resource "aws_ecs_cluster" "project1_ext" {
  name = var.project_name
}

resource "aws_ecs_task_definition" "project1_ext" {
  family = var.project_name
  container_definitions = jsonencode([
    {
      name      = "wordpress container"
      image     = "wordpress:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "http"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "project1_ext" { 
  name = var.project_name
  cluster = aws_ecs_cluster.project1_ext.id
  task_definition = aws_ecs_task_definition.project1_ext.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.subnet_private_ids
    security_groups  =  [aws_security_group.ecs_sg.id]
  }
  iam_role = aws_iam_role.ecs-iam-role.arn
}

resource "aws_security_group" "ecs_sg" {

 description = "ECS Security Group"
  vpc_id = var.vpc_id
  name   = "project1_ext1_ecs_sg"

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
    protocol  = "all"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}



