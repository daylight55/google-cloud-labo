data "cloudflare_zone" "domain" {
  name = var.tfvars.domain
}

# CloudDNSのネームサーバーをサブドメインに設定
resource "cloudflare_record" "ns" {
  for_each = toset(var.name_servers)

  zone_id = data.cloudflare_zone.domain.id
  name    = var.tfvars.subdomain
  content = each.key
  type    = "NS"
  ttl     = 3600
}
