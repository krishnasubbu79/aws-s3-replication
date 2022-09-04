resource "aws_iam_role" "s3_source_role" {
  count              = local.replication_enabled
  name_prefix        = "s3-replication_role"
  description        = "Replication role for ${var.app_name}-${var.environment}-${var.source_region} S3 bucket"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "TrustRoleS3Replication",
        "Effect": "Allow",
        "Principal": {
            "Service": "s3.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "s3_source_replication_policy" {
  count       = local.replication_enabled
  name_prefix = "${var.app_name}-${var.environment}-s3-replication-policy-"
  description = "Replication policy for ${var.app_name}-${var.environment} S3 bucket"
  policy      = data.aws_iam_policy_document.s3_source_replication_policy[count.index].json
}

data "aws_iam_policy_document" "s3_source_replication_policy" {
  count = local.replication_enabled

  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold",
    ]

    resources = [
      var.source_bucket_name_arn,
      "${var.source_bucket_name_arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
    ]

    resources = [
      "${var.destination_bucket_name_arn}/*",
    ]

    condition {
      test = "StringLikeIfExists"
      values = [
        "aws:kms",
        "AES256",
      ]
      variable = "s3:x-amz-server-side-encryption"
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      var.source_bucket_name_arn
    ]

    condition {
      test     = "StringLike"
      values   = ["s3.${var.source_region}.amazonaws.com"]
      variable = "kms:ViaService"
    }

    condition {
      test     = "StringLike"
      values   = [var.source_bucket_name_arn]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
    ]

    resources = [
      var.destination_bucket_name_arn
    ]

    condition {
      test     = "StringLike"
      values   = ["s3.${var.destination_region}.amazonaws.com"]
      variable = "kms:ViaService"
    }

    condition {
      test     = "StringLike"
      values   = [var.destination_bucket_name_arn]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
  }
}

resource "aws_iam_policy_attachment" "s3_source_replication_policy_attachment" {
  count      = local.replication_enabled
  name       = "s3-source-replication-policy-attachment"
  roles      = [aws_iam_role.s3_source_role[count.index].name]
  policy_arn = aws_iam_policy.s3_source_replication_policy[count.index].arn
}

resource "aws_s3_bucket_replication_configuration" "s3_replication" {
  count  = local.replication_enabled
  bucket = var.source_bucket_id
  role   = aws_iam_role.s3_source_role[count.index].arn
  rule {
    id     = "${var.source_region}-${var.destination_region}-s3-rule"
    status = "Enabled"
    filter {}

    destination {
      bucket        = var.destination_bucket_name_arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = var.destination_kms_key_arn
      }

      metrics {
        status = "Enabled"

        event_threshold {
          minutes = 15
        }
      }

      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}
