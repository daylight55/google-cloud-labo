variable "cluster_workload_identity_pool" {
  description = "Workload Identity Pool for the GKE cluster"
  type        = string
}

variable "tfvars" {
  description = "Root terraform.tfvars file"
  type        = any
}
