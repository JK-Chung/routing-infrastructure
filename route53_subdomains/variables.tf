variable "env_root_domain" {
  type        = string
  description = "The domain name to use with the provided subdomains. This variable can itself be a subdomain (e.g. dev.small.domains). In that case, the subdomains will be prefixed to that value."
}

variable "subdomains" {
  type        = set(string)
  description = "A set of subdomains to register under the Route 53 Zone"
  default     = []
}

variable "route53_zone_id" {
  type        = string
  description = "The Zone ID of the Route 53 Zone we are placing records into."
}

variable "to_alias_to" {
  type = object({
    name    = string
    zone_id = string
  })

  description = "Provide information for the Route 53 alias record (see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#alias)"
}

# AWS Networking Credentials
variable "NETWORKING_AWS_ACCESS_KEY_ID" {
  type        = string
  description = "The AWS Access Key ID for Networking-Infrastructure account"
}

variable "NETWORKING_AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "The AWS Access Secret Key for Networking-Infrastructure account"
  sensitive   = true
}