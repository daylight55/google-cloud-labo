output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_location" {
  value = google_container_cluster.default.location
}
