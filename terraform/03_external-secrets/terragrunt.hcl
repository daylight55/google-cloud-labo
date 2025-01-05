include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "gke" {
  config_path = find_in_parent_folders("gke/terragrunt.hcl")
}
