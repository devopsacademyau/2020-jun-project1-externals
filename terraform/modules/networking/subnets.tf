data "aws_availability_zones" "available" {}


locals {
  availability_zones_count = 2
}

resource "aws_subnet" "public" {
  count = local.availability_zones_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false # Each resource must specifically request a public IP.

  tags = {
    Name = "wp_public_${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count = local.availability_zones_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index + 10)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "wp_private_${data.aws_availability_zones.available.names[count.index]}"
  }
}
