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
  }
}