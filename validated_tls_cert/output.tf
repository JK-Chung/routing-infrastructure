output "certificate_arn" {
  value       = aws_acm_certificate.tls.arn
  description = "The ARN of the TLS certificate created"
}