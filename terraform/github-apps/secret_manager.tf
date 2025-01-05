#
# Google Secret Manager
#
# OAuth Client IDとSecretをSecret Managerに保存
resource "google_secret_manager_secret" "github_oauth_client_id" {
  secret_id = "argocd-github-oauth-client-id"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_oauth_client_id" {
  secret      = google_secret_manager_secret.github_oauth_client_id.id
  secret_data = github_oauth_application.argocd.client_id
}

resource "google_secret_manager_secret" "github_oauth_client_secret" {
  secret_id = "argocd-github-oauth-client-secret"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_oauth_client_secret" {
  secret      = google_secret_manager_secret.github_oauth_client_secret.id
  secret_data = github_oauth_application.argocd.client_secret
}

# Private KeyをSecret Managerに保存
resource "google_secret_manager_secret" "github_app_key" {
  secret_id = "argocd-github-app-key"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_app_key" {
  secret      = google_secret_manager_secret.github_app_key.id
  secret_data = tls_private_key.github_app.private_key_pem
}

# GitHub App IDをSecret Managerに保存
resource "google_secret_manager_secret" "github_app_id" {
  secret_id = "argocd-github-app-id"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_app_id" {
  secret      = google_secret_manager_secret.github_app_id.id
  secret_data = github_app.argocd.app_id
}
