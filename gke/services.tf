resource "google_project_service" "services" {
  for_each = toset([
    "container.googleapis.com", # GKE
    "containerregistry.googleapis.com",
  ])

  project = var.tfvars.project.project
  service = each.key

  disable_dependent_services = false # サービスを無効化した時に依存リソースを削除しない
  disable_on_destroy         = false # サービスを無効化した時に削除をスキップ
}
