resource "aws_s3_bucket" "route53_backup" {
  bucket = "${local.aws_global_level_id}-backup"

  acl           = "private"
  force_destroy = false

  versioning {
    enabled = var.enable_versioning
  }

  lifecycle_rule {
    id      = "wholebucket-noncurrent"
    prefix  = "/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 732
    }
  }

  logging {
    target_bucket = "${local.aws_bucket_access_log}-account-access-logs"
    target_prefix = "${local.aws_global_level_id}-backup"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.route53_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = merge(
    local.default_tags,
    map(
      "Name", local.aws_global_level_id,
    ),
  )
}
