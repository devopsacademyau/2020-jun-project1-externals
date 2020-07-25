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

