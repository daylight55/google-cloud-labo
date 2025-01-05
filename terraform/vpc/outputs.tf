output "network_name" {
  value = google_compute_network.default.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.private_subnet.name
}
