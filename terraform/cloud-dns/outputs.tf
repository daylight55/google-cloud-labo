output "name_servers" {
  value = google_dns_managed_zone.main.name_servers
}

output "managed_zone" {
  value = google_dns_managed_zone.main.name
}
