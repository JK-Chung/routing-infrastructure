resource "aws_route53_record" "subdomain_alias_records" {
  for_each = var.subdomains

  name    = "${each.value}.${var.route53_zone_name}"
  type    = "A"
  zone_id = var.route_53_zone_id

  alias {
    name    = var.to_alias_to.name
    zone_id = var.to_alias_to.zone_id
  }
}