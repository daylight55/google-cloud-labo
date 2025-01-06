resource "google_certificate_manager_certificate" "wildcard" {
  name        = "${local.env.prefix}-wildcard-cert"
  description = "Wildcard certificate for *.${local.env.subdomain}.${local.env.domain}"
  scope       = "DEFAULT"
  managed {
    domains = ["*.${local.env.subdomain}.${local.env.domain}"]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.wildcard.id
    ]
  }
}

resource "google_certificate_manager_dns_authorization" "wildcard" {
  name        = "${local.env.prefix}-wildcard-dns-auth"
  description = "DNS Authorization for wildcard certificate"
  domain      = "${local.env.subdomain}.${local.env.domain}"
}

# DNS検証用のレコードを作成する
resource "google_dns_record_set" "wildcard" {
  name         = google_certificate_manager_dns_authorization.wildcard.dns_resource_record[0].name
  type         = google_certificate_manager_dns_authorization.wildcard.dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.wildcard.dns_resource_record[0].data]
  managed_zone = var.managed_zone
}

resource "google_certificate_manager_certificate_map" "basic" {
  name        = "${local.env.prefix}-certificate-map"
  description = "Basic certificate map"
}

resource "google_certificate_manager_certificate_map_entry" "wildcard" {
  name         = "${local.env.prefix}-wildcard-entry"
  description  = "Certificate map entry for wildcard certificate"
  map          = google_certificate_manager_certificate_map.basic.name
  certificates = [google_certificate_manager_certificate.wildcard.id]
  hostname     = "*.${local.env.subdomain}.${local.env.domain}"

  depends_on = [google_certificate_manager_dns_authorization.wildcard]
}
