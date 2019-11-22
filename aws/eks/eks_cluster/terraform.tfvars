# TERRAGRUNT CONFIGURATION
terragrunt = {
  terraform {
    source = "git::ssh://git@github.com:johnwatson484/terraform.git//aws//eks//eks_cluster"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

terraform = {
  backend "s3" {}
}
