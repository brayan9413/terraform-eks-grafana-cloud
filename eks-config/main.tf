terraform {
  required_version = ">= 1.3.2" # eks module requirement
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.20" # EKS add-ons requirement > 2.20
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47" # EKS add-ons requirement > 5.0
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.1" # Grafana requirement
    }
  }

  # NOTE: Terraform backend is configured with terragrunt in the root terragrunt.hcl file
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.eks_cluster_name
      Environment = var.env_name
      Billing_tag = "Kubernetes"
    }
  }
}

# The Helm provider is used to deploy software packages in Kubernetes
# - https://registry.terraform.io/providers/hashicorp/helm/latest/docs#exec-plugins
provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    }
  }
}

# The Kubernetes (K8S) provider is used to interact with the resources supported by Kubernetes
# - https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#exec-plugins
provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
  }
}
