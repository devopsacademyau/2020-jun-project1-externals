# Setup aws provider

provider "aws" {
  region = var.region
}


# Initialize availability zone data from AWS
data "aws_availability_zones" "available" {}

# Vpc resource
resource "aws_vpc" "wp_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "wp_vpc"
  }
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp_vpc.id

  tags = {
    Name = "wp_igw"
  }
}

# Subnet (public)
resource "aws_subnet" "wp_public_subnet_az_a" {
  vpc_id                  = aws_vpc.wp_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "wp_publicsubnet_az_a"
  }
}

resource "aws_subnet" "wp_public_subnet_az_b" {
  vpc_id                  = aws_vpc.wp_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "wp_publicsubnet_az_b"
  }
}

# Subnet (private)
resource "aws_subnet" "wp_private_subnet_az_a" {
  vpc_id                  = aws_vpc.wp_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "wp_privatesubnet_az_a"
  }
}

# Subnet (private)
resource "aws_subnet" "wp_private_subnet_az_b" {
  vpc_id                  = aws_vpc.wp_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "wp_privatesubnet_az_b"
  }
}

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
  cidr_block     = var.yourhomenetworkip
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
  cidr_block     = var.yourhomenetworkip
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



# Routing table for public subnets
resource "aws_route_table" "wp_rt_public" {
  vpc_id = aws_vpc.wp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp_igw.id
  }

  tags = {
    Name = "wp_rt_public"
  }
}

resource "aws_route_table_association" "wp_route_a" {

  subnet_id      = aws_subnet.wp_public_subnet_az_a.id
  route_table_id = aws_route_table.wp_rt_public.id
}

resource "aws_route_table_association" "wp_route_b" {
  subnet_id      = aws_subnet.wp_public_subnet_az_b.id
  route_table_id = aws_route_table.wp_rt_public.id
}


# Routing table for private subnets
resource "aws_route_table" "wp_rt_private" {
  vpc_id = aws_vpc.wp_vpc.id

  tags = {
    Name = "wp_rt_private"
  }
}

resource "aws_route_table_association" "wp_private_route_a" {
  subnet_id      = aws_subnet.wp_private_subnet_az_a.id
  route_table_id = aws_route_table.wp_rt_private.id
}

resource "aws_route_table_association" "wp_private_route_b" {
  subnet_id      = aws_subnet.wp_private_subnet_az_b.id
  route_table_id = aws_route_table.wp_rt_private.id
}