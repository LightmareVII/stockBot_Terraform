terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}

variable "creds" {
  type = map
}

variable "domain" {
  type = string
}

variable "cidr" {
  type = map
}

variable "address" {
  type = map
}

provider "aws" {
  region = var.creds.region
  access_key = var.creds.access
  secret_key = var.creds.secret
}

resource "aws_vpc" "stockBot-VPC" {
  cidr_block = var.cidr.vpc
  tags = {
    Name = "stockBot-VPC",
    project = "stockBot"
  }
}

resource "aws_subnet" "stockBot-Subnet-Public" {
  vpc_id     = aws_vpc.stockBot-VPC.id
  cidr_block = var.cidr.public
  availability_zone = join("",[var.creds.region, "a"])
  map_public_ip_on_launch = true

  tags = {
    Name = "stockBot-Subnet-Public"
    project = "stockBot"
  }
}

resource "aws_subnet" "stockBot-Subnet-Private" {
  vpc_id     = aws_vpc.stockBot-VPC.id
  cidr_block = var.cidr.private
  availability_zone = join("",[var.creds.region, "a"])

  tags = {
    Name = "stockBot-Subnet-Private"
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

resource "aws_route_table_association" "stockBot-RT_Assoc_Public" {
  subnet_id      = aws_subnet.stockBot-Subnet-Public.id
  route_table_id = aws_route_table.stockBot-RT-Public.id

  depends_on = [aws_route_table.stockBot-RT-Public]
}

resource "aws_route_table_association" "stockBot-RT_Assoc_Private" {
  subnet_id      = aws_subnet.stockBot-Subnet-Private.id
  route_table_id = aws_route_table.stockBot-RT-Private.id

  depends_on = [aws_route_table.stockBot-RT-Private]
}

resource "aws_network_acl" "stockBot-NACL-Public" {
  vpc_id = aws_vpc.stockBot-VPC.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "stockBot-NACL-Public"
    project = "stockBot"
  }
  depends_on = [aws_vpc.stockBot-VPC]
}

resource "aws_network_acl" "stockBot-NACL-Private" {
  vpc_id = aws_vpc.stockBot-VPC.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "stockBot-NACL-Private"
    project = "stockBot"
  }
  depends_on = [aws_vpc.stockBot-VPC]
}

resource "aws_route_table_association" "stockBot-RT-Assoc-Public" {
  subnet_id      = aws_subnet.stockBot-Subnet-Public.id
  route_table_id = aws_route_table.stockBot-RT-Public.id
}

resource "aws_route_table_association" "stockBot-RT-Assoc-Private" {
  subnet_id      = aws_subnet.stockBot-Subnet-Private.id
  route_table_id = aws_route_table.stockBot-RT-Private.id
}

resource "aws_security_group" "stockBot-SG-SSH_ICMP-Public" {
  name        = "stockBot-SG-SSH_ICMP-Public"
  description = "Allow SSH and ICMP inbound traffic"
  vpc_id      = aws_vpc.stockBot-VPC.id

  ingress {
    description      = "SSH from Home"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr.home]
  }

  ingress {
    description      = "ICMP from Home"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = [var.cidr.home]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "stockBot-SG-SSH_ICMP-Public"
    project = "stockBot"
  }
}

resource "aws_security_group" "stockBot-SG-SSH_ICMP-Private" {
  name        = "stockBot-SG-SSH_ICMP-Private"
  description = "Allow SSH and ICMP inbound traffic"
  vpc_id      = aws_vpc.stockBot-VPC.id

  ingress {
    description      = "SSH from stockBot-VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr.vpc]
  }

  ingress {
    description      = "ICMP from stockBot-VPC"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = [var.cidr.vpc]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "stockBot-SG-SSH_ICMP-Private"
    project = "stockBot"
  }
}

resource "aws_network_interface" "stockBot-NI-JumpBox" {
  subnet_id   = aws_subnet.stockBot-Subnet-Public.id
  private_ips = [var.address.jumpbox]

  security_groups = [aws_security_group.stockBot-SG-SSH_ICMP-Public.id]

  tags = {
    Name = "stockBot-NI-Public-JumpBox"
    project = "stockBot"
  }
}

resource "aws_network_interface" "stockBot-NI-DataStream" {
  subnet_id   = aws_subnet.stockBot-Subnet-Private.id
  private_ips = [var.address.datastream]

  tags = {
    Name = "stockBot-NI-Private-DataStream"
    project = "stockBot"
  }
}

resource "aws_instance" "stockBot-JumpBox" {

  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "stockBot-KeyPair"

  network_interface {
    network_interface_id = aws_network_interface.stockBot-NI-JumpBox.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  user_data = <<EOF
  #!/bin/bash
  sudo apt-get update -y && sudo apt-get upgrade -y
  sudo mkdir /stockBot-Keys
  EOF

  tags = {
    Name = "stockBot-JumpBox"
    project = "stockBot"
  }
}

resource "aws_instance" "stockBot-DataStream" {

  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "stockBot-KeyPair"

  network_interface {
    network_interface_id = aws_network_interface.stockBot-NI-DataStream.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  user_data = <<EOF
  #!/bin/bash
  sudo apt-get update -y && sudo apt-get upgrade -y
  sudo mkdir /stockBot-Data
  EOF

  tags = {
    Name = "stockBot-DataStream"
    project = "stockBot"
  }
}

data "aws_route53_zone" "zone" {
  name         = join("", [var.domain, "."])
  private_zone = false
}

resource "aws_route53_record" "stockBot-JumpBox-A_Record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "aws.${data.aws_route53_zone.zone.name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.stockBot-JumpBox.public_ip]

  depends_on = [aws_instance.stockBot-JumpBox]
}