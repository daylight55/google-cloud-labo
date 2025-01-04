resource "google_iam_workload_identity_pool" "main" {
  workload_identity_pool_id = "${local.prefix}-pool"
  display_name              = "GKE Workload Identity Pool"
  description               = "Identity pool for GKE workload identity"
}

resource "google_iam_workload_identity_pool_provider" "main" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = "${local.prefix}-provider"
  display_name                       = "GKE Provider"
  description                        = "Workload Identity Pool Provider for GKE"

  attribute_mapping = {
    "google.subject"            = "assertion.sub"
    "attribute.aud"             = "assertion.aud"
    "attribute.namespace"       = "assertion.namespace"
    "attribute.service_account" = "assertion.service_account"
  }

  oidc {
    allowed_audiences = ["https://kubernetes.default.svc.cluster.local"]
    issuer_uri        = "https://container.googleapis.com/v1/${local.project}/locations/${local.region}/clusters/${data.terraform_remote_state.gke.outputs.cluster_name}"
  }
}
