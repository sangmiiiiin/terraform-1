# Output 생성된 EC2 인스턴스의 퍼블릭 IP 주소
output "bastion_pulic_ip" {
    value = module.ec2_instance_bastion.public_ip
}

output "ubuntu1_pulic_ip" {
    value = module.ec2_instance_ubuntu1.public_ip
}

output "ubuntu2_pulic_ip" {
    value = module.ec2_instance_ubuntu2.public_ip
}

output "amazon1_pulic_ip" {
    value = module.ec2_instance_amazon1.public_ip
}

output "amazon2_pulic_ip" {
    value = module.ec2_instance_amazon2.public_ip
}
