resource "aws_acm_certificate" "tls" {
  domain_name       = var.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn = aws_acm_certificate.tls
  validation_record_fqdns = [
    for record in aws_route53_record.tls_verification[each.value.domain_name] : record.fqdn
  ]
}