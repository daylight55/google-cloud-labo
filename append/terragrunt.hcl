include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "gke" {
  config_path = find_in_parent_folders("gke/terragrunt.hcl")
}

inputs = {
  cluster_workload_identity_pool = dependency.gke.outputs.cluster_workload_identity_pool
}

generate "provider_override" {
  # NOTE: 後からproviderを追加したい時のファイル名
  # https://developer.hashicorp.com/terraform/language/files/override#merging-terraform-blocks
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.49.1"
    }
  }
}

provider "cloudflare" {
  api_token = var.tfvars.cloudflare_api_token
}
EOF
}
