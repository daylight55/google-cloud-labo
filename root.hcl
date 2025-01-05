locals {
  inputs = jsondecode(read_tfvars_file("${get_path_to_repo_root()}/terraform.tfvars"))
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
