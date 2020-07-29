output "ssh_command" {
  value = "ssh -i ${local_file.bastion_private_key.filename} ec2-user@${aws_instance.this.public_ip}"
}
