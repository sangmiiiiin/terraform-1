module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.vpc_name}-vpc" # VPC 이름 설정

  cidr = var.vpc_cidr # VPC의 IP 주소 범위
  azs  = var.azs      # 사용할 가용 영역 (여러 AZ를 사용하여 고가용성 확보)

  public_subnets  = var.public_subnets  # 퍼블릭 서브넷 (인터넷 연결 리소스용)
  private_subnets = var.private_subnets # 프라이빗 서브넷 (내부 리소스용)

  enable_nat_gateway   = false # NAT 게이트웨이 활성화 (프라이빗 서브넷에서 인터넷 접근 가능)
  single_nat_gateway   = false # 단일 NAT 게이트웨이 사용 (비용 절감)
  enable_dns_hostnames = true # DNS 호스트네임 활성화
}

