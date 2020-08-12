resource "aws_db_subnet_group" "this" {
  name       = "rdssubnet"
  subnet_ids = var.subnet_private_ids

  tags = {
    Name = "RDS DB Subnet Group"
  }
}


resource "aws_rds_cluster" "this" {
  database_name                   = "wordpress"
  engine                          = "aurora"
  engine_mode                     = "serverless"
  db_subnet_group_name            = aws_db_subnet_group.this.name
  apply_immediately               = true
  skip_final_snapshot             = true
  backup_retention_period         = 1
  deletion_protection             = false
  storage_encrypted               = true
  vpc_security_group_ids          = [aws_security_group.rds.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_mysql57_parameter_group.id
  master_username                 = "root"
  master_password                 = random_password.rds_password.result
  scaling_configuration {
    auto_pause               = true
    max_capacity             = 256
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}


resource "random_password" "rds_password" {
  length  = 10
  special = false
}


resource "aws_db_parameter_group" "aurora_db_mysql57_parameter_group" {
  name        = "test-aurora57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_mysql57_parameter_group" {
  name        = "test-aurora57-cluster-parameter-group"
  family      = "aurora5.6"
  description = "test-aurora57-cluster-parameter-group"
}

resource "aws_security_group" "rds" {
  description = "RDS SG"
  vpc_id      = var.vpc_id
  name        = "project1_ext1_rds_sg"
}


resource "aws_security_group_rule" "allow_baston_access" {
  type                     = "ingress"
  from_port                = aws_rds_cluster.this.port
  to_port                  = aws_rds_cluster.this.port
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group
  security_group_id        = aws_security_group.rds.id
}

resource "aws_security_group_rule" "allow_ec2_access" {
  type                     = "ingress"
  from_port                = aws_rds_cluster.this.port
  to_port                  = aws_rds_cluster.this.port
  protocol                 = "tcp"
  source_security_group_id = var.sg_ecs
  security_group_id        = aws_security_group.rds.id
}