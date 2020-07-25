# Internet gateway for the public subnets
resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp_vpc.id

  tags = {
    Name = "wp_igw"
  }
}