variable "env_domain_name" {
  type        = string
  description = "The root domain for this environment (e.g. dev.small.domains)"
}

variable "apex_domain" {
  type        = string
  description = "The apex domain (i.e. NOT dev.small.domains but just small.domains)"
}

variable "env_nameservers" {
  type        = set(string)
  description = "The nameservers handling DNS queries for this specific environment."
}