#
# Github App
#
resource "github_app" "argocd" {
  name        = "ArgoCD"
  url         = "https://argocd.${var.tfvars.subdomain}.${var.tfvars.domain}"
  description = "ArgoCD GitHub App for GitOps"

  webhook_active = true
  webhook_url    = "https://argocd.${var.tfvars.subdomain}.${var.tfvars.domain}/api/webhook"

  # 必要な権限の設定
  permissions {
    contents            = "read"
    metadata            = "read"
    pull_requests       = "read"
    workflows           = "read"
    repository_projects = "read"
  }

  # イベントの設定
  events = [
    "push",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment"
  ]
}

# # GitHub OAuth Appの作成
# resource "github_oauth_application" "argocd" {
#   name         = "ArgoCD OAuth"
#   url          = "https://argocd.${var.tfvars.subdomain}.${var.tfvars.domain}"
#   callback_url = "https://argocd.${var.tfvars.subdomain}.${var.tfvars.domain}/auth/callback"
#   description  = "OAuth application for ArgoCD authentication"
# }

# # GitHub App installationのための設定
# resource "github_app_installation" "argocd" {
#   app_id     = github_app.argocd.app_id
#   repository = var.tfvars.repository_name

#   repository_ids = [
#     data.github_repository.repo.repo_id
#   ]
# }

# # リポジトリ情報の取得
# data "github_repository" "repo" {
#   full_name = var.tfvars.repository_name
# }

# # GitHub App Private Keyの生成
# resource "tls_private_key" "github_app" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }
