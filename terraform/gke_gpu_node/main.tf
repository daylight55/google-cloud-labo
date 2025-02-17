resource "google_container_node_pool" "gpu_pool" {
  name       = "${var.tfvars.prefix}-gpu-pool"
  cluster    = var.cluster_id
  location   = var.tfvars.zone
  node_count = 1

  node_config {
    machine_type = "g2-standard-4"

    guest_accelerator {
      type  = "nvidia-l4"
      count = 1
    }

    labels = {
      "cloud.google.com/gke-accelerator" = "nvidia-l4"
    }

    metadata = {
      "gpu-driver-version" = "latest"
    }

    taint {
      key    = "nvidia.com/gpu"
      value  = "present"
      effect = "NO_SCHEDULE"
    }
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
