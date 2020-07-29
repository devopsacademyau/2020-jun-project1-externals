

#############
# RDS Aurora
#############
module "aurora" {
  source                = "git@github.com:terraform-aws-modules/terraform-aws-rds-aurora.git"
  name                  = var.db_name
  database_name         = "wordpress"
  engine                = var.db_engine
  engine_mode           = var.engine_mode
  replica_scale_enabled = var.replica_scale_enabled
  replica_count         = var.replica_count

  backtrack_window      = var.backtrack_window # ignored in serverless

  subnets                         = var.subnet_private_ids
  # subnets                         = [
  #  "subnet-080d66f82c68fe96b",  # da-c02-private-a
  #  "subnet-03b9a6d084a3b586b",  # da-c02-private-b
  #  "subnet-069d2eb4c2921ab78"   # da-c02-private-c
  # ]
  vpc_id                          = var.vpc_id # data.aws_vpc.da-c02-vpc.id
  monitoring_interval             = var.monitoring_interval
  instance_type                   = var.db_instance_type
  apply_immediately               = var.apply_immediately
  skip_final_snapshot             = var.skip_final_snapshot
  backup_retention_period         = var.backup_retention_period
  deletion_protection             = var.deletion_protection
  storage_encrypted               = var.storage_encrypted
  performance_insights_enabled    = var.performance_insights_enabled
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_mysql57_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_mysql57_parameter_group.id
  allowed_security_groups         = var.allowed_security_groups

  scaling_configuration = {
    auto_pause               = true
    #https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.how-it-works.html
    max_capacity             = 256
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}


# aws rds create-db-parameter-group help
# aws  rds   describe-db-engine-versions   --query   "DBEngineVersions[].DBParameterGroupFamily"
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
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

############################
# Example of security group
############################
resource "aws_security_group" "app_servers" {
  name        = "app-servers"
  description = "For application servers"
  vpc_id      = var.vpc_id # data.aws_vpc.da-c02-vpc.id
}

resource "aws_security_group_rule" "allow_access" {
  type                     = "ingress"
  from_port                = module.aurora.this_rds_cluster_port
  to_port                  = module.aurora.this_rds_cluster_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_servers.id
  security_group_id        = module.aurora.this_security_group_id
}
