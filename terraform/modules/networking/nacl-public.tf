resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = {
    Name = "wp_public_nacl"
  }
}

resource "aws_network_acl_rule" "public_ingress_ssh_from_home_network" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.your_home_network_cidr
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_ingress_ephemeral_vpc" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_egress_ssh_vpc" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_egress_ephemeral_home_network" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.your_home_network_cidr
  from_port      = 1024
  to_port        = 65535
}
