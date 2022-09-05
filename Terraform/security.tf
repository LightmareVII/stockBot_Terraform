resource "aws_security_group" "stockBot-SG-SSH_ICMP-Private" {
  name        = "stockBot-SG-SSH_ICMP-Private"
  description = "Allow SSH and ICMP inbound traffic"
  vpc_id      = aws_vpc.stockBot-VPC.id

  ingress {
    description = "SSH from stockBot-VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.addressing.networks.vpc]
  }

  ingress {
    description = "ICMP from stockBot-VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.addressing.networks.vpc]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "stockBot-SG-SSH_ICMP-Private"
    project = "stockBot"
  }
}

resource "aws_security_group" "stockBot-SG-SSH_ICMP-Public" {
  name        = "stockBot-SG-SSH_ICMP-Public"
  description = "Allow SSH and ICMP inbound traffic"
  vpc_id      = aws_vpc.stockBot-VPC.id

  ingress {
    description = "SSH from Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.addressing.hosts.home]
  }

  ingress {
    description = "ICMP from Home"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.addressing.hosts.home]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "stockBot-SG-SSH_ICMP-Public"
    project = "stockBot"
  }
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
    Name    = "stockBot-NACL-Public"
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
    Name    = "stockBot-NACL-Private"
    project = "stockBot"
  }
  depends_on = [aws_vpc.stockBot-VPC]
}