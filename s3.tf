resource "aws_s3_bucket" "access_logs" {
  bucket = "alb-access-logs"

}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs
  
  rule {
    id = "auto-expire"

    expiration {
      days = 90
    }
  }
}