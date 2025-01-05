resource "google_compute_network" "default" {
  name                    = "${var.tfvars.prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "${var.tfvars.prefix}-subnet"
  ip_cidr_range = "10.0.0.0/24" # NodeのIPアドレス範囲
  network       = google_compute_network.default.id
  region        = var.tfvars.region

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "10.1.0.0/20" # PodのIPアドレス範囲
  }
  secondary_ip_range {
    range_name    = "service-ranges"
    ip_cidr_range = "10.2.0.0/20" # ServiceのIPアドレス範囲
  }
}

resource "google_compute_router" "private_subnet" {
  name    = "${var.tfvars.prefix}-router"
  region  = var.tfvars.region
  network = google_compute_network.default.id
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
  name                               = "${var.tfvars.prefix}-nat"
  router                             = google_compute_router.private_subnet.name
  region                             = var.tfvars.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  # ログ有効化
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
