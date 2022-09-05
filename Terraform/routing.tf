resource "aws_route_table" "stockBot-RT-Public" {
  vpc_id = aws_vpc.stockBot-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stockBot-IGW.id
  }

  tags = {
    Name = "stockBot-RT-Public"
    project = "stockBot"
  }

  depends_on = [aws_internet_gateway.stockBot-IGW]
}

resource "aws_route_table" "stockBot-RT-Private" {
  vpc_id = aws_vpc.stockBot-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.stockBot-NGW.id
  }

  tags = {
    Name = "stockBot-RT-Private"
    project = "stockBot"
  }
  depends_on = [aws_nat_gateway.stockBot-NGW]
}