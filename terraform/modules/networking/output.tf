output "vpc_id" {
  value = aws_vpc.wp_vpc.id
}
output "subnet_private_ids" {
  value = list(aws_subnet.wp_private_subnet_az_a.id,aws_subnet.wp_private_subnet_az_b.id)
}
