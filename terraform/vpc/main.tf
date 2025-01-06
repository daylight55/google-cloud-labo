resource "google_compute_network" "default" {
  name                    = "${local.env.prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "${local.env.prefix}-subnet"
  ip_cidr_range = "10.0.0.0/24" # NodeのIPアドレス範囲
  network       = google_compute_network.default.id
  region        = local.env.region

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
  name    = "${local.env.prefix}-router"
  region  = local.env.region
  network = google_compute_network.default.id
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
  name                               = "${local.env.prefix}-nat"
  router                             = google_compute_router.private_subnet.name
  region                             = local.env.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  # ログ有効化
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
