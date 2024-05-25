include {
  path = find_in_parent_folders()
}

# Run `terragrunt output` on the module at the relative path `../eks-cluster` and create them under the attribute
# `dependency.eks-cluster.outputs`
# - https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency
dependency "eks-cluster" {
  config_path = "../eks-cluster"

  # To avoid errors when dependency isn't applied yet
  mock_outputs = {
    eks_oidc_provider                      = "123456"
    eks_cluster_endpoint                   = "eks_cluster_endpoint"
    eks_cluster_certificate_authority_data = "ZXhhbXBsbGU="
    eks_cluster_name                         = "123456"
  }

  mock_outputs_merge_with_state           = true
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "destroy"]
}

inputs = {
  eks_oidc_provider                      = dependency.eks-cluster.outputs.eks_oidc_provider
  eks_cluster_endpoint                   = dependency.eks-cluster.outputs.eks_cluster_endpoint
  eks_cluster_certificate_authority_data = dependency.eks-cluster.outputs.eks_cluster_certificate_authority_data
  eks_cluster_name                       = dependency.eks-cluster.outputs.eks_cluster_name
}
