resource "aws_route53_record" "subdomain_alias_records" {
  for_each = local.elb_routable_apps

  name    = each.value.fqdn
  type    = "A"
  zone_id = aws_ssm_parameter.r53_zoneids[each.value.env_root_domain].value

  alias {
    name                   = aws_lb.common_lb.dns_name
    zone_id                = aws_lb.common_lb.zone_id
    evaluate_target_health = true
  }
}