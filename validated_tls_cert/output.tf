output "tls_cert" {
  value       = aws_acm_certificate.tls
  description = "The ACM certificate created for TLS"
}