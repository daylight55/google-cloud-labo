resource "google_compute_network" "default" {
  name                    = "${local.prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "${local.prefix}-subnet"
  ip_cidr_range = "10.0.0.0/24" # NodeのIPアドレス範囲
  network       = google_compute_network.default.id
  region        = local.region

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "10.1.0.0/20" # PodのIPアドレス範囲
  }
  secondary_ip_range {
    range_name    = "service-ranges"
    ip_cidr_range = "10.2.0.0/20" # ServiceのIPアドレス範囲
  }
}

# Private Service Connect用のサブネット
resource "google_compute_subnetwork" "psc_subnet" {
  name          = "${local.prefix}-psc-subnet"
  ip_cidr_range = "10.3.0.0/24"
  network       = google_compute_network.default.id
  region        = local.region
  purpose       = "PRIVATE_SERVICE_CONNECT"
}

# Private Service Connect用のエンドポイント
resource "google_compute_global_address" "psc_endpoint" {
  name          = "${local.prefix}-psc-endpoint"
  address_type  = "INTERNAL"
  purpose       = "PRIVATE_SERVICE_CONNECT"
  network       = google_compute_network.default.id
  address       = "10.3.0.2"
  prefix_length = 24
}

resource "google_compute_router" "private_subnet" {
  name    = "${local.prefix}-router"
  region  = local.region
  network = google_compute_network.default.id
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
  name                               = "${local.prefix}-nat"
  router                             = google_compute_router.private_subnet.name
  region                             = local.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  # ログ有効化
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
