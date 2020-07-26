#NACL for Public subnets
resource "aws_network_acl" "wp_public_nacl" {
  vpc_id     = aws_vpc.wp_vpc.id
  subnet_ids = [aws_subnet.wp_public_subnet_az_a.id, aws_subnet.wp_public_subnet_az_b.id]

  tags = {
    Name = "wp_public_nacl"
  }
}

# accept SSH requests from your home network CIDR 
resource "aws_network_acl_rule" "wp_public_nacl_allow_traffic_your_homenetwork" {
  network_acl_id = aws_network_acl.wp_public_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.your_home_network_cidr
  from_port      = 22
  to_port        = 22
}

# accept ephermel port
resource "aws_network_acl_rule" "wp_public_nacl_ephemeral_in" {
  network_acl_id = aws_network_acl.wp_public_nacl.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 1024
  to_port        = 65535
}

# accept SSH request from 10.0.0.0/16
resource "aws_network_acl_rule" "wp_public_nacl_ephemeral_out1" {
  network_acl_id = aws_network_acl.wp_public_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 22
  to_port        = 22
}

# accept ephermel port 
resource "aws_network_acl_rule" "wp_public_nacl_ephemeral_out2" {
  network_acl_id = aws_network_acl.wp_public_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.your_home_network_cidr
  from_port      = 1024
  to_port        = 65535
}

#NACL for Private subnets
resource "aws_network_acl" "wp_private_nacl" {
  vpc_id     = aws_vpc.wp_vpc.id
  subnet_ids = [aws_subnet.wp_private_subnet_az_a.id, aws_subnet.wp_private_subnet_az_b.id]

  tags = {
    Name = "wp_private_nacl"
  }
}

# accept SSH requests from 10.0.0.0/16 CIDR 
resource "aws_network_acl_rule" "wp_private_nacl_allow_local_traffic" {
  network_acl_id = aws_network_acl.wp_private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 22
  to_port        = 22
}

# accept ephermel port
resource "aws_network_acl_rule" "wp_private_nacl_ephemeral_in" {
  network_acl_id = aws_network_acl.wp_private_nacl.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 1024
  to_port        = 65535
}

# accept SSH request from 10.0.0.0/16
resource "aws_network_acl_rule" "wp_private_nacl_ephemeral_out1" {
  network_acl_id = aws_network_acl.wp_private_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 22
  to_port        = 22
}

# accept ephermel port
resource "aws_network_acl_rule" "wp_private_nacl_ephemeral_out2" {
  network_acl_id = aws_network_acl.wp_private_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 1024
  to_port        = 65535
}


