data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_s3control_multi_region_access_point" "s3_mrap" {
  count = local.create_mrap
  details {
    name = "s3-mrap-${var.environment}-${var.source_region}-${var.destination_region}"
    region {
      bucket = var.source_bucket_name_id
    }

    region {
      bucket = var.destination_bucket_name_id
    }

    public_access_block {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }
  }
}

// s3 MRAP policy
resource "aws_s3control_multi_region_access_point_policy" "s3_mrap_policy" {
  count = local.create_mrap
  details {
    name = element(split(":", aws_s3control_multi_region_access_point.s3_mrap[count.index].id), 1)
    policy = data.aws_iam_policy_document.s3_mrap_policy[count.index].json
  }
}

// data block for the policy
data "aws_iam_policy_document" "s3_mrap_policy" {
  count = local.create_mrap
  statement {
    sid    = "DenyUnsecureTransport"
    effect = "Deny"

    resources = [
      "arn:${data.aws_partition.current.partition}:s3::${data.aws_caller_identity.current.account_id}:accesspoint/${aws_s3control_multi_region_access_point.s3_mrap[count.index].alias}/object/*"
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
      "arn:${data.aws_partition.current.partition}:s3::${data.aws_caller_identity.current.account_id}:accesspoint/${aws_s3control_multi_region_access_point.s3_mrap[count.index].alias}/object/*"
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
}