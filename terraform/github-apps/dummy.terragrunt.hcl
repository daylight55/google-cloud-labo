include "root" {
  path = find_in_parent_folders("root.hcl")
}

generate "provider_override" {
  # https://registry.terraform.io/providers/integrations/github/latest
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.4.0"
    }
  }
}

# Use GitHub CLI
# https://registry.terraform.io/providers/integrations/github/latest/docs#github-cli
provider "github" {}
EOF
}
