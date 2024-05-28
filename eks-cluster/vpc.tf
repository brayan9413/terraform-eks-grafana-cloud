#--------------------------------------------------------------------
# - VPC
# This module creates a new VPC resource on AWS
#--------------------------------------------------------------------
data "aws_availability_zones" "available" {}

locals {
  cluster_name = "br-eks-sample"
  private_subnets = [
    "${var.vpc_cidr_prefix}.0.0/19", # 8190 hosts per subnet
    "${var.vpc_cidr_prefix}.32.0/19",
    "${var.vpc_cidr_prefix}.64.0/19"
  ]
  intra_subnets = [
    "${var.vpc_cidr_prefix}.96.0/22", # 1022 host per subnet
    "${var.vpc_cidr_prefix}.100.0/22",
    "${var.vpc_cidr_prefix}.104.0/22"
  ]
  public_subnets = [
    "${var.vpc_cidr_prefix}.108.0/22", # 1022 host per subnet
    "${var.vpc_cidr_prefix}.112.0/22",
    "${var.vpc_cidr_prefix}.116.0/22"
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.0"

  name                 = "br-eks-vpc"
  cidr                 = "${var.vpc_cidr_prefix}.0.0/16"
  azs                  = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets      = local.private_subnets
  public_subnets       = local.public_subnets
  intra_subnets        = local.intra_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true # Enable DNS hostnames for resources within the VPC
  enable_dns_support   = true # Enable DNS resoulution of hostnames within the VPC

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    Public                                        = true
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    Private                                       = true
    NAT_gateway                                   = true
  }

  private_route_table_tags = { Name = "br-eks-vpc-private", Private = true }
  public_route_table_tags  = { Name = "br-eks-vpc-public", Public = true }
}
