variable "kubernetes_version" {
  default     = 1.29
  description = "kubernetes version"
}

variable "vpc_cidr_prefix" {
  default     = "10.0"
  description = "The first 2 octets of the IPv4 address space"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "aws region"
}

variable "env_name" {
  description = "Environment of component ex. dev, qa1, stg, prod."
  default     = "dev"
}

# EKS config
variable "node_group_instance_type_list" {
  description = "node_group instace type list"
  default     = ["t2.micro"]
}
