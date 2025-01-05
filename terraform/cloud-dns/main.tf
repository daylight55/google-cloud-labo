resource "google_dns_managed_zone" "main" {
  name        = "${var.tfvars.subdomain}-zone"
  dns_name    = "${var.tfvars.subdomain}.${var.tfvars.domain}."
  description = "DNS zone for ${var.tfvars.subdomain} environment"

  visibility = "public"
}
