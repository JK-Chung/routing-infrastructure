resource "aws_route53_zone" "projects" {
  for_each = local.env_root_domain
  name     = each.value
}

module "route53_cross_account" {
  for_each = local.env_root_domain
  providers = {
    aws = aws.networking-infrastructure
  }

  source          = "./route53_cross_account"
  env_domain_name = each.value
  apex_domain     = regex("[^\\.]+\\..+$", each.value)
  env_nameservers = aws_route53_zone.projects[each.value].name_servers
}

module "route53_subdomains" {
  for_each = local.env_root_domain
  source   = "./route53_subdomains"

  env_root_domain = each.value
  subdomains      = [for r in local.elb_routable_apps : r.subdomain if r.env_root_domain == each.value]
  route53_zone_id = aws_route53_zone.projects[each.value].zone_id

  to_alias_to = {
    name    = aws_lb.common_lb.dns_name
    zone_id = aws_lb.common_lb.zone_id
  }
}