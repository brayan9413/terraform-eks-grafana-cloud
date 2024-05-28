#---------------------------------------------------------------
# - EKS
# Terraform module to create AWS Elastic Kubernetes (EKS) resources
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
#---------------------------------------------------------------
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.5"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = module.vpc.private_subnets

  cluster_endpoint_public_access           = true
  enable_irsa                              = true # OpenID Connect Provider for EKS to enable IRSA - IAM roles for SA
  enable_cluster_creator_admin_permissions = true # To add the current caller identity as an administrator

  tags = {
    cluster = local.cluster_name
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64" # Amazon linux 2
    instance_types = var.node_group_instance_type_list
    iam_role_additional_policies = {
      policies = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" # IAM policy needed by EBS CSI driver
    }
  }

  eks_managed_node_groups = {
    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }
}

# EKS blueprints - https://github.com/aws-ia/terraform-aws-eks-blueprints-addons
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller = true
  # enable_karpenter                    = true # node autoscaling, It needs additional config https://aws-ia.github.io/terraform-aws-eks-blueprints/patterns/karpenter-mng/
  # enable_kube_prometheus_stack = true
  enable_metrics_server        = true
  # enable_external_dns                 = true
}
