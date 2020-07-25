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