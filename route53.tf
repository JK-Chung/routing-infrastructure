
resource "aws_route53_zone" "routable_applications" {
  for_each = { for a in local.routable_applications : a.domain_name => a }
  name     = each.value.domain_name
}

resource "aws_route53_record" "for_tls_verification" {
  for_each = flatten([
    for domain_name, records in local.all_dns_records_for_tls_validation : records
  ])

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.routable_applications[each.value.domain_name].zone_id
}