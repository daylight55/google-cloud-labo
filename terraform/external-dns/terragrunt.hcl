include "root" {
  path = find_in_parent_folders("root.hcl")
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

dependencies {
  paths = [
    "../common",
    "../gke"
  ]
}

dependency "cloud-dns" {
  config_path = find_in_parent_folders("cloud-dns/terragrunt.hcl")
  mock_outputs = {
    name_servers = ["ns-cloud-dns1.googledomains.com", "ns-cloud-dns2.googledomains.com", "ns-cloud-dns3.googledomains.com", "ns-cloud-dns4.googledomains.com"]
  }
}

inputs = {
  name_servers = dependency.cloud-dns.outputs.name_servers
}
