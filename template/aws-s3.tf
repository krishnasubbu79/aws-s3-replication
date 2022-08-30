module "s3_create_source_bucket" {
  source                        = "../modules/aws-s3-bucket"
  block_public_acls             = var.block_public_acls
  block_public_policy           = var.block_public_policy
  ignore_public_acls            = var.ignore_public_acls
  restrict_public_buckets       = var.restrict_public_buckets
  s3_bucket_creation_enabled    = var.s3_source_bucket_creation_enabled
  environment                   = var.environment
  app_name                      = var.app_name
  bucket_name                   = var.bucket_name
  region                        = var.source_region
  s3_bucket_replication_enabled = var.s3_bucket_replication_enabled

  tags = {
    Name = "s3source"
  }

  enable_backup      = var.source_enable_backup
  versioning_status  = var.enable_versioning
  log_bucket         = var.source_log_bucket
  s3_lifecycle_rules = var.s3_lifecycle_rules
  kms_key_arn        = var.source_kms_key_arn

  providers = {
    aws = aws.source
  }
}

module "s3_create_destination_bucket" {
  source                        = "../modules/aws-s3-bucket"
  block_public_acls             = var.block_public_acls
  block_public_policy           = var.block_public_policy
  ignore_public_acls            = var.ignore_public_acls
  restrict_public_buckets       = var.restrict_public_buckets
  s3_bucket_creation_enabled    = var.s3_destination_bucket_creation_enabled
  environment                   = var.environment
  app_name                      = var.app_name
  bucket_name                   = var.bucket_name
  region                        = var.destination_region
  s3_bucket_replication_enabled = var.s3_bucket_replication_enabled

  tags = {
    Name = "s3destination"
  }
  enable_backup      = var.destination_enable_backup
  versioning_status  = var.enable_versioning
  log_bucket         = var.destination_log_bucket
  s3_lifecycle_rules = var.s3_lifecycle_rules
  kms_key_arn        = var.destination_kms_key_arn

  providers = {
    aws = aws.destination
  }
}
