resource "aws_route53_record" "subdomain_alias_records" {
  for_each = { for a in local.elb_routable_apps : a.fqdn => a }

  name    = each.value.fqdn
  type    = "A"
  zone_id = data.aws_ssm_parameter.r53_zoneids[each.value.env_root_domain].value

  alias {
    name                   = aws_lb.common_lb.dns_name
    zone_id                = aws_lb.common_lb.zone_id
    evaluate_target_health = true
  }
}