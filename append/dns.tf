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

locals {
  # NOTE: applyエラーの回避
  name_servers = [for ns in google_dns_managed_zone.main.name_servers : ns]
}

# CloudDNSのネームサーバーをサブドメインに設定
resource "cloudflare_record" "ns" {
  for_each = toset(local.name_servers)

  zone_id = data.cloudflare_zone.domain.id
  name    = var.tfvars.subdomain
  content = each.key
  type    = "NS"
  ttl     = 3600

  depends_on = [google_dns_managed_zone.main]
}
