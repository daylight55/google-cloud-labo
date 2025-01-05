locals {
  k8s_external_secret_namespace = "external-secrets"
  k8s_external_secret_sa_name   = "external-secrets"
  k8s_external_secret_sa_fqn    = "serviceAccount:${var.tfvars.project}.svc.id.goog[${local.k8s_external_secret_namespace}/${local.k8s_external_secret_sa_name}]"
}

#
# External Secrets
#
resource "google_service_account" "external_secrets" {
  account_id   = local.k8s_external_secret_sa_name
  display_name = "External Secrets Operator Service Account"
  description  = "Service account for External Secrets Operator to access Secret Manager"
}

# Secret Manager へのアクセス権限付与
resource "google_project_iam_member" "external_secrets" {
  project = var.tfvars.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.external_secrets.email}"
}

# Workload Identity の IAM 設定
resource "google_service_account_iam_member" "external_secrets" {
  service_account_id = google_service_account.external_secrets.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_external_secret_sa_fqn
}
