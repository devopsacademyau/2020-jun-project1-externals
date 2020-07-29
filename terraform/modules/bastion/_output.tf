output "security_group_id" {
  value = aws_security_group.this.id
}

output "ssh_command" {
  value = "ssh -i ${local_file.bastion_private_key.filename} ec2-user@${aws_instance.this.public_ip}"
}
