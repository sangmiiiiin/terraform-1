# 보안 그룹 생성
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow HTTP inbound traffic and all outbound traffic"

  tags = {
    Name = "web-sg"
  }

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# ubuntu 최신버전의 ami 이미지 검색
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"] # x86_64 아키텍처를 사용하는 AMI만 선택
  }

  owners = ["099720109477"] # Canonical(Ubuntu) 공식 Owner ID
}

# output "ubuntu_ami_id" {
#   value = data.aws_ami.ubuntu.image_id # 검색된 최신 AMI의 ID 출력
# }

resource "aws_instance" "ubuntu_web_ec2" {
  ami           = data.aws_ami.ubuntu.image_id # ubuntu
  instance_type = "t2.micro"
  key_name      = "multi-key"
  security_groups = [aws_security_group.web-sg.name]

  tags = {
    Name = "ubuntu-web"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo '<h1>Hello From Your Ubuntu Web Server!</h1>' > /var/www/html/index.html                
              EOF
}