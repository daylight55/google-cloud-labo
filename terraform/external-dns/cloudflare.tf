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

# DNSSECのDSレコードを設定
resource "cloudflare_record" "ds" {
  zone_id = data.cloudflare_zone.domain.id
  name    = var.tfvars.subdomain
  type    = "DS"
  data {
    key_tag     = tonumber(split(" ", var.dnssec_ds_record)[0])
    algorithm   = tonumber(split(" ", var.dnssec_ds_record)[1])
    digest_type = tonumber(split(" ", var.dnssec_ds_record)[2])
    digest      = upper(split(" ", var.dnssec_ds_record)[3])
  }
  ttl = 3600
}
