variable "name_servers" {
  type        = list(string)
  description = "Name servers for the domain"
}

variable "dnssec_ds_record" {
  type        = string
  description = "DNSSEC DS record for the domain"
}
