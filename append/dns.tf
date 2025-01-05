#
# Cloud DNS
#
resource "google_dns_managed_zone" "main" {
  name        = "${var.tfvars.subdomain}-zone"
  dns_name    = "${var.tfvars.subdomain}.${data.cloudflare_zone.domain.name}."
  description = "DNS zone for ${var.tfvars.subdomain} environment"

  visibility = "public"

  dnssec_config {
    state = "on"
  }
}

#
# Cloudflare
#
data "cloudflare_zone" "domain" {
  name = var.tfvars.domain
}

# CloudDNSのネームサーバーをサブドメインに設定
resource "cloudflare_record" "ns" {
  for_each = toset(google_dns_managed_zone.main.name_servers)

  zone_id = data.cloudflare_zone.domain.id
  name    = var.tfvars.subdomain
  content = each.key
  type    = "NS"
  ttl     = 3600

  depends_on = [google_dns_managed_zone.main]
}
