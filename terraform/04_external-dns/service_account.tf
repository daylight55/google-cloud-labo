locals {
  # External DNS
  k8s_external_dns_namespace = "external-dns"
  k8s_external_dns_sa_name   = "external-dns"
  k8s_external_dns_sa_fqn    = "serviceAccount:${var.tfvars.project}.svc.id.goog[${local.k8s_external_dns_namespace}/${local.k8s_external_dns_sa_name}]"

}

resource "google_service_account" "external_dns" {
  account_id   = local.k8s_external_dns_sa_name
  display_name = "External DNS Service Account"
  description  = "Service account for External DNS to manage Cloud DNS records"
}

# Cloud DNS管理権限の付与
resource "google_project_iam_member" "external_dns" {
  project = var.tfvars.project
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external_dns.email}"
}

# Workload Identity の IAM 設定
resource "google_service_account_iam_member" "external_dns" {
  service_account_id = google_service_account.external_dns.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_external_dns_sa_fqn
}
