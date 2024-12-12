data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-20*-x86_64"]
  }
  
  owners = ["137112412989"]
}

module "ec2_instance_amazon1" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  name                        = "amazon1"
  instance_type               = "t2.micro"
  key_name                    = "multi-key"
  vpc_security_group_ids      = [aws_security_group.server_sg.id]
  ami                         = data.aws_ami.amazon.image_id
  associate_public_ip_address = true # 퍼블릭 IP 할당
  subnet_id                   = module.vpc.public_subnets[0]

  tags = {
    Name = "amazon1"
  }
}


module "ec2_instance_amazon2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  name                        = "amazon2"
  instance_type               = "t2.micro"
  key_name                    = "multi-key"
  vpc_security_group_ids      = [aws_security_group.server_sg.id]
  ami                         = data.aws_ami.amazon.image_id
  associate_public_ip_address = true # 퍼블릭 IP 할당
  subnet_id                   = module.vpc.public_subnets[1]

  tags = {
    Name = "amazon2"
  }
}