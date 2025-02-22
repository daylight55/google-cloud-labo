resource "google_storage_bucket" "terraform-state-store" {
  name          = var.tfstate_bucket
  location      = "us-west1" # 無料枠にするため
  storage_class = "REGIONAL"

  versioning {
    enabled = true
  }

  # バージョンを5つ保持する
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 5
    }
  }
}
