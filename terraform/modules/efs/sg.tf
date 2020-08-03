resource "aws_security_group" "efs_sg" {

  description = "EFS Security Group"
  vpc_id      = var.vpc_id
  name        = "project1_ext1_efs_sg"

  ingress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [var.sg_ecs]
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

