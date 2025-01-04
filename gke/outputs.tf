output "cluster_endpoint" {
  value = google_container_cluster.default.endpoint
}

output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_id" {
  value = google_container_cluster.default.id
}

output "cluster_workload_identity_pool" {
  value = google_container_cluster.default.workload_identity_config[0].workload_pool
}
