locals {
  inputs = yamldecode(file("${find_in_parent_folders("env.yaml")}"))
}

inputs = {
  tfvars = local.inputs
}

generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.inputs.project}"
  region  = "us-west1"
}

provider "google-beta" {
  project = "${local.inputs.project}"
  region  = "us-west1"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.14.1"
    }
  }
}
EOF
}

remote_state {
  backend = "gcs"
  config = {
    bucket = "${local.inputs.tfstate_bucket}"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "variables" {
  path      = "_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "tfvars" {
  type    = map(string)
  default = {}
  description = "Root terraform.tfvars file"
}
EOF
}
