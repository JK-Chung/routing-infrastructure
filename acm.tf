resource "aws_acm_certificate" "routable_applications" {
  for_each          = { for a in local.routable_applications : a.domain_name => a }
  domain_name       = each.value.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "routable_applications" {
  for_each        = aws_acm_certificate.routable_applications
  certificate_arn = each.value.arn
  validation_record_fqdns = [
    for record in aws_route53_record.for_tls_verification : record.fqdn
    if contains(each.value.domain_validation_options[*].name, record.name)
  ]
}