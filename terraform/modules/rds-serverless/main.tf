
module "aurora" {
  source                = "git@github.com:terraform-aws-modules/terraform-aws-rds-aurora.git"
  name                  = "wordpress"
  database_name         = "wordpress"
  engine                = "aurora"
  engine_mode           = "serverless"
  replica_scale_enabled = false
  replica_count         = 0
  backtrack_window      = 10

  subnets                         = var.subnet_private_ids
  vpc_id                          = var.vpc_id
  monitoring_interval             = 60
  instance_type                   = "db.t2.small"
  apply_immediately               = true
  skip_final_snapshot             = true
  backup_retention_period         = 1
  deletion_protection             = false
  storage_encrypted               = true
  performance_insights_enabled    = false
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_mysql57_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_mysql57_parameter_group.id
  allowed_security_groups         = var.allowed_security_groups

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 256
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
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

resource "aws_security_group_rule" "allow_access" {
  type                     = "ingress"
  from_port                = module.aurora.this_rds_cluster_port
  to_port                  = module.aurora.this_rds_cluster_port
  protocol                 = "tcp"
  source_security_group_id = var.sg_ecs
  security_group_id        = module.aurora.this_security_group_id
}
