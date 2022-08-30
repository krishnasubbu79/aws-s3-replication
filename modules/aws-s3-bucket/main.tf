data "aws_caller_identity" "self" {
  count = local.bucket_creation_enabled
}

resource "aws_s3_bucket" "bucket" {
  count  = local.bucket_creation_enabled
  bucket = local.bucket_name

  force_destroy = true
  tags          = merge(local.tags, var.tags)
}

resource "aws_s3_bucket_public_access_block" "s3_block_public_access" {
  count  = local.bucket_creation_enabled
  bucket = aws_s3_bucket.bucket[count.index].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  count  = local.bucket_creation_enabled
  bucket = aws_s3_bucket.bucket[count.index].id

  versioning_configuration {
    status = var.versioning_status # should be "Enabled" for versioning to work
  }
}

resource "aws_s3_bucket_logging" "s3_bucket_logging" {
  count         = local.bucket_creation_enabled
  bucket        = aws_s3_bucket.bucket[count.index].id
  target_bucket = var.log_bucket
  target_prefix = "${data.aws_caller_identity.self[0].id}/${local.bucket_name}}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_server_side_encryption" {
  count  = local.bucket_creation_enabled
  bucket = aws_s3_bucket.bucket[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }

    bucket_key_enabled = true
  }
}

// Bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  count  = local.bucket_creation_enabled
  bucket = aws_s3_bucket.bucket[count.index].id
  policy = data.aws_iam_policy_document.s3_bucket_policy[count.index].json

  // Create public access block before bucket policy is added
  depends_on = [aws_s3_bucket_public_access_block.s3_block_public_access]
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  count = local.bucket_creation_enabled
  statement {
    sid    = "DenyUnSecureCommunications"
    effect = "Deny"

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*"
    ]

    actions = [
      "s3:*"
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }

  statement {
    sid    = "DenySSE-s3-writes"
    effect = "Deny"

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*"
    ]

    actions = [
      "s3:PutObject"
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "StringEquals"
      values   = ["AES256"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }

  statement {
    sid    = "RequireEncryptedObjects"
    effect = "Deny"

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*"
    ]

    actions = [
      "s3:PutObject"
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "StringNotLikeIfExists"
      values   = [var.kms_key_arn]
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
    }
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  count  = local.bucket_creation_enabled
  bucket = aws_s3_bucket.bucket[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle_configuration" {
  count  = local.bucket_creation_enabled
  bucket = aws_s3_bucket.bucket[count.index].id

  dynamic "rule" {
    for_each = concat(
      var.s3_lifecycle_rules,
      [
        {
          id                                     = "BucketLifecycleRules"
          enabled                                = "Enabled"
          abort_incomplete_multipart_upload_days = 3
        }
      ]
    )

    content {
      abort_incomplete_multipart_upload {
        days_after_initiation = lookup(rule.value, "abort_incomplete_multipart_upload_days", null)
      }

      status = rule.value.enabled
      id     = lookup(rule.value, "id", null)
      prefix = lookup(rule.value, "prefix", null)

      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", [])
        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lookup(rule.value, "noncurrent_version_expiration", [])
        content {
          noncurrent_days = lookup(noncurrent_version_expiration.value, "noncurrent_days", null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lookup(rule.value, "noncurrent_version_transition", [])
        content {
          noncurrent_days = lookup(noncurrent_version_transition.value, "noncurrent_days", null)
          storage_class   = lookup(noncurrent_version_transition.value, "storage_class", null)
        }
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transition", [])
        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = lookup(transition.value, "storage_class", null)
        }
      }
    }
  }
}

resource "aws_s3_bucket_metric" "s3_metrics" {
  count  = local.bucket_creation_enabled
  bucket = aws_s3_bucket.bucket[count.index].id
  name   = "EntireBucket"
}