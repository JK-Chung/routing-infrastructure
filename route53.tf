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

resource "aws_route53_record" "smalldomains_web_app_cloudfront_domain_name" {
  name    = format("pages.%ssmall.domains", var.environment == "prod" ? "" : "${var.environment}.")
  type    = "A"
  zone_id = data.aws_ssm_parameter.r53_zoneids[format("%ssmall.domains", var.environment == "prod" ? "" : "${var.environment}.")].value

  alias {
    name                   = data.aws_ssm_parameter.smalldomains_web_app_cloudfront_domain_name.value
    zone_id                = data.aws_ssm_parameter.smalldomains_web_app_cloudfront_hosted_zone_id.value
    evaluate_target_health = true
  }
}