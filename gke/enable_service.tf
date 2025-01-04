resource "google_project_service" "services" {
  for_each = toset([
    "container.googleapis.com", # GKE
    "containerregistry.googleapis.com",
  ])

  project = local.project
  service = each.key
}
