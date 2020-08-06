output "bastion_ssh_command" {
  value = module.bastion.ssh_command
}

output "mysql_command" {
  value = {
    command  = "mysql -h ${module.rds.this_rds_cluster_endpoint} -u ${module.rds.this_rds_cluster_master_username} -p ${module.rds.this_rds_cluster_database_name}"
    password = module.rds.this_rds_cluster_master_password
  }
}

output "ecs_details" {
  value = {
    cluster_name = module.ecs.ecs_cluster_name
    service_name = module.ecs.ecs_service_name
  }
}

output "ecr_url" {
  value = module.ecs.ecr_url
}