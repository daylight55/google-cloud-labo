locals {
  workload_identity_pool = data.terraform_remote_state.gke.outputs.cluster_workload_identity_pool
  # External Secrets
  k8s_external_secret_namespace = "external-secrets"
  k8s_external_secret_sa_name   = "external-secrets"
  k8s_external_secret_sa_fqn    = "${local.workload_identity_pool}/[${local.k8s_external_secret_namespace}/${local.k8s_external_secret_sa_name}]"
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
resource "google_project_iam_member" "secret_accessor" {
  project = local.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.external_secrets.email}"
}

# Workload Identity の IAM 設定
resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.external_secrets.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_external_secret_sa_fqn
}
