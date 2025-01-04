output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_id" {
  value = google_container_cluster.primary.id
}

output "cluster_workload_identity_pool" {
  value = google_container_cluster.primary.workload_identity_config[0].workload_pool
}
