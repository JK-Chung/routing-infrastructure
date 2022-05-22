resource "aws_route53_record" "subdomain_alias_records" {
  for_each = var.subdomains

  name    = "${each.value}.${var.env_root_domain}"
  type    = "A"
  zone_id = var.route53_zone_id

  alias {
    name                   = var.to_alias_to.name
    zone_id                = var.to_alias_to.zone_id
    evaluate_target_health = true
  }
}