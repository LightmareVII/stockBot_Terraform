resource "aws_instance" "stockBot-JumpBox" {

  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name      = "stockBot-KeyPair"

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
    Name    = "stockBot-JumpBox"
    project = "stockBot"
  }
}

resource "aws_instance" "stockBot-DataStream" {

  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name      = "stockBot-KeyPair"

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
    Name    = "stockBot-DataStream"
    project = "stockBot"
  }
}