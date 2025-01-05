resource "google_container_cluster" "default" {
  name     = "${var.tfvars.prefix}-cluster"
  location = var.tfvars.zone

  initial_node_count       = 1
  remove_default_node_pool = true

  network    = var.network_name
  subnetwork = var.subnetwork_name

  workload_identity_config {
    workload_pool = "${var.tfvars.project}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "service-ranges"
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  logging_service    = "none"
  monitoring_service = "none"

  release_channel {
    channel = "STABLE"
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
}

# Spot VMを使用したノードプール
resource "google_container_node_pool" "default" {
  name       = "${var.tfvars.prefix}-node-pool"
  location   = var.tfvars.zone
  cluster    = google_container_cluster.default.name
  node_count = 1

  autoscaling {
    min_node_count = 2
    max_node_count = 10
  }

  node_config {
    machine_type = "e2-medium" # コスト効率の良いマシンタイプ

    # Spot VMの設定
    spot = false

    # カスタムサービスアカウントを使用
    service_account = google_service_account.gke_sa.email

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
