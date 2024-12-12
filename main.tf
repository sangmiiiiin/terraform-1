terraform {
  required_version = ">=1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # 5.1.x 이상, 6.0.0 미만 허용
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-042e76978adeb8c48" # ubuntu 22.04
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.name]
  key_name   = "multi-key"
  tags = {
    Name = "ubuntu-web"
  }

  # user data 추가
  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt -y install httpd
              systemctl enable --now httpd
              echo '<h1>Hello From Ubuntu Web Server!</h1>' > /var/www/html/index.html                
              EOF
}

# 보안 그룹 생성
resource "aws_security_group" "allow_ssh" {
  name        = "web-sg"
  description = "Allow HTTP inbound traffic and all outbound traffic"

  tags = {
    Name = "web-sg"
  }
}

# Ingress Rule: anywhere에서 80포트 허용
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0" # Anywhere (IPv4)
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Engress Rule: anywhere 허용
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0" # 모든 IPv4 트래픽 허용
  ip_protocol       = "-1" # 모든 프로토콜 허용
}

# 추후에 security_group 변경할것