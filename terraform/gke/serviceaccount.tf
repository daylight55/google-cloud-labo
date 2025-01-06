# GKEノード用のサービスアカウント
resource "google_service_account" "gke_sa" {
  account_id   = "${local.env.prefix}-sa"
  display_name = "${local.env.prefix} Service Account"
  description  = "Service account for GKE nodes"
}

# サービスアカウントへの必要な権限の付与
resource "google_project_iam_member" "gke_sa_roles" {
  for_each = toset([
    "roles/monitoring.metricWriter",            # メトリクスの書き込み
    "roles/monitoring.viewer",                  # メトリクスの閲覧
    "roles/logging.logWriter",                  # ログの書き込み
    "roles/artifactregistry.reader",            # コンテナイメージの取得
    "roles/stackdriver.resourceMetadata.writer" # リソースメタデータの書き込み
  ])

  project = local.env.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}
