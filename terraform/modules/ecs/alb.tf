resource "aws_alb" "wp_alb" {
  name            = "${var.project_name}-alb"
  subnets         = var.subnet_public_ids   
  security_groups = [var.wpalb_sg_id]
  internal        = false
  load_balancer_type         = "application"
  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.project_name
  }
}

# Target Group for wordpress
resource "aws_alb_target_group" "target_group" {
  name        = "wordpressalbtg01"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

    health_check {
    interval = 60
    path     = "/index.html"
    port     = 80
    protocol = "HTTP"
    timeout  = 30
    matcher  = "200-302,404"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb.wp_alb]
}


# ALB Security Group
resource "aws_security_group" "wpalb_sg" {
  name        = "project1_ext1_wpalb_sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.alb_port
    to_port     = var.alb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project1_ext1_wpalb_sg"
  }
}