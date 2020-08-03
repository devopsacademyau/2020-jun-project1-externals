output "sg_ecs_id" {
  value = aws_security_group.wordpress.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.wordpress.name
}