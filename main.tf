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
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["142.188.159.9/32"]
  }
  egress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["35.203.94.19/32",
                   "34.152.28.44/32",
                   "54.213.119.159/32",
                   "34.218.159.79/32",
                   "52.33.16.117/32",
                   "3.225.222.13/32",
                   "34.197.160.162/32",
                   "3.213.188.29/32",
                   "35.164.189.142/32",
           	       "35.166.154.241/32",
                   "35.160.254.91/32",
                   "35.168.234.8/32",
                   "34.204.215.165/32",
                   "54.92.237.118/32"


] #[aws_vpc.main.cidr_block]
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
    Name = "GFLAWS-RPA1"
  }
}
resource "tls_private_key" "instance" {
  algorithm = "RSA"
}

resource "aws_key_pair" "instance" {
  key_name   = var.key_name
  public_key = tls_private_key.instance.public_key_openssh
  tags = {
    Name = "rpaprod_keypair"
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


