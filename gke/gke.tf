resource "google_container_cluster" "primary" {
  name     = "${local.prefix}-cluster"
  location = local.zone

  initial_node_count       = 1
  remove_default_node_pool = true

  network    = google_compute_network.default.name
  subnetwork = google_compute_subnetwork.private_subnet.name

  workload_identity_config {
    workload_pool = "${local.project}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "service-ranges"
  }

  # Private Cluster の設定
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false  # Cloud Shellからのアクセスを許可
    master_ipv4_cidr_block = "172.16.0.0/28"

    master_global_access_config {
      enabled = true  # マスターへのグローバルアクセスを有効化
    }
  }

  # Private Service Connect の設定
  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled = false
  }

  logging_service    = "none"
  monitoring_service = "none"

  release_channel {
    channel = "STABLE"
  }

  depends_on = [google_project_service.services]
}

# Spot VMを使用したノードプール
resource "google_container_node_pool" "spot_nodes" {
  name       = "${local.prefix}-node-pool"
  location   = local.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  node_config {
    machine_type = "e2-medium" # コスト効率の良いマシンタイプ

    # Spot VMの設定
    spot = true

    # カスタムサービスアカウントを使用
    service_account = google_service_account.gke_sa.email

    # ファイアウォールルール用のタグを追加
    tags = [
      "${local.prefix}-gke"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  depends_on = [google_project_service.services]
}
