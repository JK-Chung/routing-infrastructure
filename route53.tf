
resource "aws_route53_zone" "routable_applications" {
  for_each = { for a in local.routable_applications : a.domain_name => a }
  name     = each.value.domain_name
}

resource "aws_route53_record" "for_tls_verification" {
  for_each = { for r in local.all_dns_records_for_tls_validation : "${r.domain_name}${r.resource_record_name}" => r }

  allow_overwrite = true
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  type            = each.value.resource_record_type
  zone_id         = aws_route53_zone.routable_applications[each.value.domain_name].zone_id
}