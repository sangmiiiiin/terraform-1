# 변수 정의
# 이 변수들은 인프라 구성을 유연하게 만들어 줍니다.

variable "region" {
  default = "ap-northeast-2" # AWS 리전 설정
}

variable "vpc_name" {
  default = "lab" # EKS 클러스터 이름
}

variable "vpc_cidr" {
  default = "10.0.0.0/16" # VPC의 CIDR 블록
}

variable "azs" {
  default = ["ap-northeast-2a", "ap-northeast-2c"] # 사용할 가용 영역
}

variable "public_subnets" {
  default = ["10.0.0.0/24", "10.0.1.0/24"] # 퍼블릭 서브넷 CIDR
}

variable "private_subnets" {
  default = ["10.0.2.0/24", "10.0.3.0/24"] # 프라이빗 서브넷 CIDR
}
