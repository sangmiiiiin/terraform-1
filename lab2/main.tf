variable "vpc_name" {
  default = sample-vpc
}
# vpn module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws" # Terraform AWS VPC 모듈
  
  name = "lab-vpc"
  cidr = "10.0.0.0/16" # VPC의 기본 CIDR 블록

  azs             = ["ap-northeast-2a", "ap-northeast-2c"] # 가용 영역
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]         # 퍼블릭 서브넷
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]         # 프라이빗 서브넷

  enable_nat_gateway = true # NAT 게이트웨이 활성화
  single_nat_gateway = true # 단일 NAT 게이트웨이 사용
  enable_vpn_gateway = true # VPN 게이트웨이 활성화
}

#보안 그룹 생성
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow HTTP,SSH inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

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

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "web-ec2"
  instance_type = "t2.micro"
  key_name      = "multi-key"
  #   monitoring             = true
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  ami                         = data.aws_ami.ubuntu.image_id
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[1]

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

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}
