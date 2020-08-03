output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_public_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "subnet_private_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}