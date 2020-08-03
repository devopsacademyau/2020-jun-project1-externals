
resource "aws_ssm_parameter" "db_host" {
  name      = "/wordpress/WORDPRESS_DB_HOST"
  type      = "SecureString"
  value     = module.aurora.this_rds_cluster_endpoint
  overwrite = true

}

resource "aws_ssm_parameter" "db_name" {
  name      = "/wordpress/WORDPRESS_DB_NAME"
  type      = "SecureString"
  value     = module.aurora.this_rds_cluster_database_name
  overwrite = true
}

resource "aws_ssm_parameter" "db_user" {
  name      = "/wordpress/WORDPRESS_DB_USER"
  type      = "SecureString"
  value     = module.aurora.this_rds_cluster_master_username
  overwrite = false
}

resource "aws_ssm_parameter" "db_password" {
  name      = "/wordpress/WORDPRESS_DB_PASSWORD"
  type      = "SecureString"
  value     = module.aurora.this_rds_cluster_master_password
  overwrite = false
}
