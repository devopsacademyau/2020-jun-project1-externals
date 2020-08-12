
resource "aws_ssm_parameter" "db_host" {
  name      = "/wordpress/WORDPRESS_DB_HOST"
  type      = "SecureString"
  value     = aws_rds_cluster.this.endpoint
  overwrite = true

}

resource "aws_ssm_parameter" "db_name" {
  name      = "/wordpress/WORDPRESS_DB_NAME"
  type      = "SecureString"
  value     = aws_rds_cluster.this.database_name
  overwrite = true
}

resource "aws_ssm_parameter" "db_user" {
  name      = "/wordpress/WORDPRESS_DB_USER"
  type      = "SecureString"
  value     = aws_rds_cluster.this.master_username
  overwrite = false
}


resource "aws_ssm_parameter" "db_password" {
  name      = "/wordpress/WORDPRESS_DB_PASSWORD"
  type      = "SecureString"
  value     = aws_rds_cluster.this.master_password
  overwrite = false
}
