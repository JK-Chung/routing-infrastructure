data "aws_ssm_parameter" "r53_zoneids" {
  for_each = local.env_root_domain
  name     = format("/route53/%s/zone-id", each.value)
}

data "aws_ssm_parameter" "smalldomains_web_app_cloudfront_domain_name" {
  name = "/smalldomains/web-app/cloudfront-domain-name"
}

data "aws_ssm_parameter" "smalldomains_web_app_cloudfront_hosted_zone_id" {
  name = "/smalldomains/web-app/cloudfront-hosted-zone-id"
}