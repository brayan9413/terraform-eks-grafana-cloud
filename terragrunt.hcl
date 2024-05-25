#--------------------------------------------------------------------
# Root configuration for terraform
# - setup optional_var_files and remote_state
# - https://terragrunt.gruntwork.io/docs/features/keep-your-cli-flags-dry/#required-and-optional-var-files
#--------------------------------------------------------------------
terraform {
  extra_arguments "conditional_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
      "destroy"
    ]

    optional_var_files = [
      "${get_terragrunt_dir()}/vars_${get_env("TF_VAR_env_name", "dev")}.tfvars"
    ]
  }
}

# https://terragrunt.gruntwork.io/docs/features/keep-your-remote-state-configuration-dry/
# Terragrunt creates backend.tf before running any Terraform commands, ensuring backend configuration with interpolated values is applied across all modules.
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket         = "${get_env("TF_VAR_backend_s3_bucket")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${get_env("TF_VAR_backend_s3_region")}"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
EOF
}
