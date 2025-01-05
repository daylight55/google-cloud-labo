output "cluster_workload_identity_pool" {
  value = google_container_cluster.default.workload_identity_config[0].workload_pool
}
