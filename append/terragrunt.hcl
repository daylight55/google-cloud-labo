include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "gke" {
  config_path = find_in_parent_folders("gke/terragrunt.hcl")
}

inputs = {
  cluster_workload_identity_pool = dependency.gke.outputs.cluster_workload_identity_pool
}
