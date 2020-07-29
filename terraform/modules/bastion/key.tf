resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "bastion-key"
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name = "Bastion Key"
  }
}

resource "local_file" "bastion_private_key" {
  filename          = "bastion.pem"
  sensitive_content = tls_private_key.this.private_key_pem
  file_permission   = "0600"
}
