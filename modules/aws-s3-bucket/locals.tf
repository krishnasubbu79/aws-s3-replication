locals {
  bucket_creation_enabled     = var.s3_bucket_creation_enabled ? 1 : 0

  bucket_name = "${var.environment}-${var.app_name}-${var.bucket_name}-${var.region}"
  tags = {
    enabled_s3_backup = var.enable_backup
  }
}