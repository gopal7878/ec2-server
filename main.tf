# Windows AMI
data "aws_ami" "windows" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-2022.09.14"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["801119661308"]
}


#security group to allow the incoming and outgoing traffic

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #[aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.windows.id
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip
  key_name                    = aws_key_pair.instance.key_name
  subnet_id                   = var.subnet
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  vpc_security_group_ids      = [
    aws_security_group.allow_tls.id
  ]
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  tags = {
    Name = var.tag
  }
}
resource "tls_private_key" "instance" {
  algorithm = "RSA"
}

resource "aws_key_pair" "instance" {
  key_name   = var.key_name
  public_key = tls_private_key.instance.public_key_openssh
  tags = {
    Name = "test-keypair"
  }
}

# Creates and stores ssh key used creating an EC2 instance
resource "aws_secretsmanager_secret" "keystore" {
  name = var.secretsmanager_secret
}

resource "aws_secretsmanager_secret_version" "keystore" {
  secret_id     = aws_secretsmanager_secret.keystore.id
  secret_string = tls_private_key.instance.private_key_pem

}


