resource "aws_route53_record" "env_domain_name" {
  name    = var.env_domain_name
  type    = "NS"
  zone_id = data.tfe_outputs.cross_account-route53[var.apex_domain].zone_id
  records = var.env_nameservers
}