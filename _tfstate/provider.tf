provider "google" {
  project = var.project_id

  add_terraform_attribution_label               = true
  terraform_attribution_label_addition_strategy = "PROACTIVE"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.14.1"
    }
  }
}
