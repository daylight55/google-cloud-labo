resource "google_container_cluster" "primary" {
  name     = "minimal-cluster"
  location = var.zone

  initial_node_count       = 1
  remove_default_node_pool = true

  network    = google_compute_network.gke.name
  subnetwork = google_compute_subnetwork.private_subnet.name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "service-ranges"
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
  name       = "spot-node-pool"
  location   = var.zone
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
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  depends_on = [google_project_service.services]
}
