resource "aws_vpc" "stockBot-VPC" {
  cidr_block = var.addressing.networks.vpc
  tags = {
    Name = "stockBot-VPC",
    project = "stockBot"
  }
}

resource "aws_subnet" "stockBot-Subnet-Public" {
  vpc_id     = aws_vpc.stockBot-VPC.id
  cidr_block = var.addressing.networks.public
  availability_zone = join("",[var.creds.region, "a"])
  map_public_ip_on_launch = true

  tags = {
    Name = "stockBot-Subnet-Public"
    project = "stockBot"
  }
}

resource "aws_subnet" "stockBot-Subnet-Private" {
  vpc_id     = aws_vpc.stockBot-VPC.id
  cidr_block = var.addressing.networks.private
  availability_zone = join("",[var.creds.region, "a"])

  tags = {
    Name = "stockBot-Subnet-Private"
    project = "stockBot"
  }
}

resource "aws_network_interface" "stockBot-NI-JumpBox" {
  subnet_id   = aws_subnet.stockBot-Subnet-Public.id
  private_ips = [var.addressing.hosts.jumpbox]

  security_groups = [aws_security_group.stockBot-SG-SSH_ICMP-Public.id]

  tags = {
    Name = "stockBot-NI-Public-JumpBox"
    project = "stockBot"
  }
}

resource "aws_network_interface" "stockBot-NI-DataStream" {
  subnet_id   = aws_subnet.stockBot-Subnet-Private.id
  private_ips = [var.addressing.hosts.datastream]

  tags = {
    Name = "stockBot-NI-Private-DataStream"
    project = "stockBot"
  }
}

resource "aws_internet_gateway" "stockBot-IGW" {
  vpc_id = aws_vpc.stockBot-VPC.id

  tags = {
    Name = "stockBot-IGW"
    project = "stockBot"
  }
}

resource "aws_eip" "stockBot-EIP" {
  vpc = true
  depends_on = [aws_internet_gateway.stockBot-IGW]

  tags = {
    Name = "stockBot-EIP"
    project = "stockBot"
  }
}

resource "aws_nat_gateway" "stockBot-NGW" {
  allocation_id = aws_eip.stockBot-EIP.id
  subnet_id     = aws_subnet.stockBot-Subnet-Public.id

  tags = {
    Name = "stockBot-NGW"
    project = "stockBot"
  }

  depends_on = [aws_internet_gateway.stockBot-IGW, aws_eip.stockBot-EIP]
}