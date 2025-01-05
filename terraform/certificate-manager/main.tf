resource "google_certificate_manager_certificate" "wildcard" {
  name        = "${var.tfvars.prefix}-wildcard-cert"
  description = "Wildcard certificate for *.${var.tfvars.subdomain}.${var.tfvars.domain}"
  scope       = "DEFAULT"
  managed {
    domains = ["*.${var.tfvars.subdomain}.${var.tfvars.domain}"]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.wildcard.id
    ]
  }
}

resource "google_certificate_manager_dns_authorization" "wildcard" {
  name        = "${var.tfvars.prefix}-wildcard-dns-auth"
  description = "DNS Authorization for wildcard certificate"
  domain      = "${var.tfvars.subdomain}.${var.tfvars.domain}"
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
  name        = "${var.tfvars.prefix}-certificate-map"
  description = "Basic certificate map"
}

resource "google_certificate_manager_certificate_map_entry" "wildcard" {
  name         = "${var.tfvars.prefix}-wildcard-entry"
  description  = "Certificate map entry for wildcard certificate"
  map          = google_certificate_manager_certificate_map.basic.name
  certificates = [google_certificate_manager_certificate.wildcard.id]
  hostname     = "*.${var.tfvars.subdomain}.${var.tfvars.domain}"

  depends_on = [google_certificate_manager_dns_authorization.wildcard]
}
