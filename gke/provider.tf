provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.14.1"
    }
  }
}

terraform {
  backend "gcs" {
    bucket = "daylight55-terraform-state"
    prefix = "gke/terraform.tfstate"
  }
}
