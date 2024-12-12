# ubuntu1 ec2 instance 생성
module "ec2_instance_ubuntu1" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  name                        = "ubuntu1"
  instance_type               = "t2.micro"
  key_name                    = "multi-key"
  vpc_security_group_ids      = [aws_security_group.server_sg.id]
  ami                         = data.aws_ami.ubuntu.image_id
  associate_public_ip_address = true # 퍼블릭 IP 할당
  subnet_id                   = module.vpc.public_subnets[0]

  tags = {
    Name = "ubuntu1"
  }
}

# ubuntu2 ec2 instance 생성
module "ec2_instance_ubuntu2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  name                        = "ubuntu2"
  instance_type               = "t2.micro"
  key_name                    = "multi-key"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  ami                         = data.aws_ami.ubuntu.image_id
  associate_public_ip_address = true # 퍼블릭 IP 할당
  subnet_id                   = module.vpc.public_subnets[1]

  tags = {
    Name = "ubuntu2"
  }
}