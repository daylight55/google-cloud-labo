output "name_servers" {
  value = google_dns_managed_zone.main.name_servers
}

output "dnssec_ds_record" {
  value = data.google_dns_keys.main.key_signing_keys[0].ds_record
}
