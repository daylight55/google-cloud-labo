locals {
  workload_identity_pool = var.cluster_workload_identity_pool
  # External Secrets
  k8s_external_secret_namespace = "external-secrets"
  k8s_external_secret_sa_name   = "external-secrets"
  k8s_external_secret_sa_fqn    = "serviceAccount:${local.workload_identity_pool}[${local.k8s_external_secret_namespace}/${local.k8s_external_secret_sa_name}]"
  # External DNS
  k8s_external_dns_namespace = "external-dns"
  k8s_external_dns_sa_name   = "external-dns"
  k8s_external_dns_sa_fqn    = "serviceAccount:${local.workload_identity_pool}[${local.k8s_external_dns_namespace}/${local.k8s_external_dns_sa_name}]"

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
  project = local.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.external_secrets.email}"
}

# Workload Identity の IAM 設定
resource "google_service_account_iam_member" "external_secrets" {
  service_account_id = google_service_account.external_secrets.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_external_secret_sa_fqn
}

#
# External DNS
#
resource "google_service_account" "external_dns" {
  account_id   = local.k8s_external_dns_sa_name
  display_name = "External DNS Service Account"
  description  = "Service account for External DNS to manage Cloud DNS records"
}

# Cloud DNS管理権限の付与
resource "google_project_iam_member" "external_dns" {
  project = local.project
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external_dns.email}"
}

# Workload Identity の IAM 設定
resource "google_service_account_iam_member" "external_dns" {
  service_account_id = google_service_account.external_dns.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_external_dns_sa_fqn
}
