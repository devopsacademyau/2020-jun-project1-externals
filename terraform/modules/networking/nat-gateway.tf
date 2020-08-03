resource "aws_eip" "this" {
  vpc = true
}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.this.id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "wp_nat_gateway"
  }
}

