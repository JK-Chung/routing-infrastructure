module "route53_subdomains" {
  for_each = local.env_root_domain
  source   = "./route53_subdomains"

  env_root_domain = a.env_root_domain
  subdomains      = [for r in local.elb_routable_apps : r.subdomain if r.env_root_domain == each.value]
  route53_zone_id = aws_ssm_parameter.r53_zoneids[each.value.env_root_domain].value

  to_alias_to = {
    name    = aws_lb.common_lb.dns_name
    zone_id = aws_lb.common_lb.zone_id
  }
}