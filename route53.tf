
resource "aws_route53_zone" "routable_applications" {
  for_each = { for a in local.routable_applications : a.domain_name => a }
  name     = each.value.domain_name
}

resource "aws_route53_record" "for_tls_verification" {
  # Terraform's for_each doesn't accept tuples or lists so I need to implement this weird, roundabout code to turn it into a map
  for_each = { for r
    in flatten([for domain_name, records in local.all_dns_records_for_tls_validation : records]) :
    "${r.domain_name}${r.name}${r.record}" => r
  }

  # depends on required as this resource is referenced in the for_each
  depends_on = [
    aws_acm_certificate.routable_applications
  ]

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.routable_applications[each.value.domain_name].zone_id
}