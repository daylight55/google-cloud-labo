locals {
  inputs = jsondecode(read_tfvars_file("${get_path_to_repo_root()}/terraform.tfvars"))
}

generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.project_id}"
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
    bucket = "daylight55-terraform-state"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "locals" {
  path      = "_locals.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
locals {
  project        = "${local.inputs.project}"
  region         = "${local.inputs.region}"
  zone           = "${local.inputs.zone}"
  tfstate_bucket = "${local.inputs.tfstate_bucket}"
}
EOF
