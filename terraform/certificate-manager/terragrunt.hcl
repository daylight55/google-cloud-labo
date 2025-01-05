include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = [
    "../common",
    "../cloud-dns"
  ]
}

dependency "cloud-dns" {
  config_path = find_in_parent_folders("cloud-dns/terragrunt.hcl")
}

inputs = {
  managed_zone = dependency.cloud-dns.outputs.managed_zone
}