output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_id" {
  value = google_container_cluster.default.id
}

output "cluster_location" {
  value = google_container_cluster.default.location
}
