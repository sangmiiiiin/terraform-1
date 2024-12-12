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


# ec2 instance 생성
module "ec2_instance_bastion" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  name                        = "bastion"
  instance_type               = "t2.micro"
  key_name                    = "multi-key"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  ami                         = data.aws_ami.ubuntu.image_id
  associate_public_ip_address = true # 퍼블릭 IP 할당
  subnet_id                   = module.vpc.public_subnets[1]

  tags = {
    Name = "bastion"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install python3-pip -y
              pip install ansible
              EOF
}
