resource "google_project_service" "services" {
  provider = google-beta
  for_each = toset([
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "secretmanager.googleapis.com",
    "dns.googleapis.com"
  ])

  service = each.key
  project = local.project

  disable_dependent_services = false # サービスを無効化した時に依存リソースを削除しない
  disable_on_destroy         = false # サービスを無効化した時に削除をスキップ
}
