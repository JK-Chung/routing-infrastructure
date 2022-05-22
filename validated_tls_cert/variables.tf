variable "fqdn" {
  type        = string
  description = "The FQDN that we're creating and registering a TLS certificate for"
}

variable "route53_zone_id" {
  type        = string
  description = "DNS is used to verify the created TLS certs. This variable specifies the Route53 Zone we're populating the validation records into"
}