include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  network_name    = dependency.vpc.outputs.network_name
  subnetwork_name = dependency.vpc.outputs.subnetwork_name
}

dependencies {
  paths = [
    "../common",
    "../vpc",
  ]
}
