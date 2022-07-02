resource "aws_s3_bucket" "access_logs" {
  bucket_prefix = "alb-access-logs-${var.environment}"
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "auto-expire"
    status = "Enabled"

    filter {}

    expiration {
      days = 90
    }
  }
}