# 보안 그룹 생성
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id
  
  tags = {
    Name = "bastion-sg"
  }

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Engress Rule: anywhere 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "server_sg" {
  name        = "server-sg"
  description = "Allow HTTP,SSH inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "server-sg"
  }

  # Ingress Rule: anywhere에서 80포트 허용
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
  # Engress Rule: anywhere 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
