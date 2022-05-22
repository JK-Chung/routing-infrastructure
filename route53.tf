resource "aws_route53_zone" "projects" {
  for_each = local.route53_zone_names
  name     = each.value
}

module "route53_subdomains" {
  for_each = local.route53_zone_names
  source   = "./route53_subdomains"

  route53_zone_name = each.value
  subdomains        = [for r in local.elb_routable_apps : r.subdomain if r.route53_zone_name == each.value]
  route53_zone_id   = aws_route53_zone.projects[each.value].zone_id

  to_alias_to = {
    name    = aws_lb.common_lb.dns_name
    zone_id = aws_lb.common_lb.zone_id
  }
}