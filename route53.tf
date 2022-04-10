resource "aws_route53_zone" "small_domains" {
  name = format("%ssmall.domains",
    var.environment == "prod" ? "" : "${var.environment}."
  )
}