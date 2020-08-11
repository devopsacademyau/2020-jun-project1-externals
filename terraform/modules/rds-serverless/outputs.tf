
output "this_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.this.endpoint
}

output "this_rds_cluster_master_username" {
  description = "The master username"
  value       = aws_rds_cluster.this.master_username
}

output "this_rds_cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = aws_rds_cluster.this.database_name
}

output "this_rds_cluster_master_password" {
  description = "The master password"
  value       = aws_rds_cluster.this.master_password
}
