data "aws_ssm_parameter" "r53_zoneids" {
  for_each = local.env_root_domain
  name     = format("/route53/%s/zone-id", each.value)
}