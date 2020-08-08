output "sg_ecs_id" {
  value = aws_security_group.wordpress.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.wordpress.name
}

output "alb" {
  value = aws_alb.wp_alb.dns_name
}

output "wpalb_sg_id" {
  value = aws_security_group.wpalb_sg.id
}

output "ecr_url" {
  value = aws_ecr_repository.wprepo.repository_url
}

