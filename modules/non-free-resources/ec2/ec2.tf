data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_security_group" "allow_ssh_from_world" {
  name        = "allow_ssh_from_world"
  description = "Allow SSH inbound traffic from world"

  ingress {
    description = "SSH from world"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "allow_ssh_from_world"
    yor_trace = "6d156ca6-048f-4c6d-ad95-89df03eb09da"
  }
}


resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon-2.id
  instance_type               = "t3.nano"
  iam_instance_profile        = "privesc-high-priv-service-profile"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_from_world.id]

  tags = {
    yor_trace = "3cd13de0-2ce5-4fdd-9d58-c184694ca9c3"
  }
}



