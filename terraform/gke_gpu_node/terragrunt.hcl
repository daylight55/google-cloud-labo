include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    network_name    = "mock-network-name"
    subnetwork_name = "mock-subnetwork-name"
  }
}

dependency "gke" {
  config_path = "../gke"

  mock_outputs = {
    cluster_id = "mock-cluster-id"
  }
}

inputs = {
  cluster_id = dependency.gke.outputs.cluster_id
}

dependencies {
  paths = [
    "../common",
    "../vpc",
    "../gke",
  ]
}
