resource "google_secret_manager_secret" "example" {
  secret_id = "external-secrets-example"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "example" {
  secret      = google_secret_manager_secret.example.id
  secret_data = "example-secret-value"
}
