resource "aws_lb_listener_certificate" "listener_certs" {
  listener_arn    = var.listener_arn
  certificate_arn = aws_acm_certificate.tls.arn
}