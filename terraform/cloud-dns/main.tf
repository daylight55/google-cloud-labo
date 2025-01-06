resource "google_dns_managed_zone" "main" {
  name        = "${local.env.subdomain}-zone"
  dns_name    = "${local.env.subdomain}.${local.env.domain}."
  description = "DNS zone for ${local.env.subdomain} environment"

  visibility = "public"
}

# NOTE: 一括削除用リソース
resource "null_resource" "dns_record_cleanup" {
  triggers = {
    zone_name = google_dns_managed_zone.main.name
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      records=$(gcloud dns record-sets list --zone=${self.triggers.zone_name} --format='get(name,type)' --filter='type!="NS" AND type!="SOA"')
      while IFS= read -r record; do
        if [ ! -z "$record" ]; then
          name=$(echo $record | cut -d' ' -f1)
          type=$(echo $record | cut -d' ' -f2)
          gcloud dns record-sets delete "$name" --type="$type" --zone=${self.triggers.zone_name} --quiet
        fi
      done <<< "$records"
    EOT
  }
}
