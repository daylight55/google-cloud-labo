data "terraform_remote_state" "gke" {
  backend = "gcs"
  config = {
    bucket = "${local.tfstate_bucket}"
    prefix = "gke/terraform.tfstate"
  }
}
