locals {
  s3_objects_common_load_balancer_prefix = "common-load-balancer"
}

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

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  policy = data.aws_iam_policy_document.s3_lb_write.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

data "aws_elb_service_account" "main" {}

# Required policy to allow for putting access logs (https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html)
data "aws_iam_policy_document" "s3_lb_write" {
  policy_id = "s3_lb_write"

  statement {
    effect = "Allow"

    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }

    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.access_logs.id}/${local.s3_objects_common_load_balancer_prefix}/*"]
  }

  statement {
    effect = "Allow"

    principals {
      identifiers = ["logdelivery.elb.amazonaws.com"]
      type        = "Service"
    }

    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.access_logs.id}"]
  }
}