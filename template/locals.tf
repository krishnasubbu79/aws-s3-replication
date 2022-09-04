locals {
  replication_enabled = var.s3_bucket_replication_enabled && var.s3_destination_bucket_creation_enabled
}