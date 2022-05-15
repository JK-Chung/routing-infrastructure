
resource "aws_route53_zone" "routable_applications" {
  for_each = { for a in local.routable_applications : a.domain_name => a }
  name     = each.value.domain_name
}

resource "aws_route53_record" "for_tls_verification" {
  for_each = flatten([for domain_name, acm in aws_acm_certificate.routable_applications : acm.domain_validation_options])

  allow_overwrite = true
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  type            = each.value.resource_record_type
  zone_id         = aws_route53_zone.routable_applications[each.value.domain_name].zone_id
}