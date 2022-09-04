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

  tags = {
    Name = "s3sourcebucket"
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
  s3_bucket_creation_enabled    = local.replication_enabled
  environment                   = var.environment
  app_name                      = var.app_name
  bucket_name                   = var.bucket_name
  region                        = var.destination_region

  tags = {
    Name = "s3destinationbucket"
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

// Creating bi-directional replication between source and destination buckets
module "s3_create_source_replication" {
  source                      = "../modules/aws-s3-replication"
  replication_enabled         = local.replication_enabled
  app_name                    = var.app_name
  environment                 = var.environment
  source_bucket_id            = module.s3_create_source_bucket.s3_bucket_id
  source_bucket_name_arn      = module.s3_create_source_bucket.s3_bucket_name_arn
  destination_bucket_name_arn = module.s3_create_destination_bucket.s3_bucket_name_arn
  source_kms_key_arn          = var.source_kms_key_arn
  destination_kms_key_arn     = var.destination_kms_key_arn
  source_region               = var.source_region
  destination_region          = var.destination_region

  providers = {
    aws = aws.source
  }
}

// Creating bi-directional replication between destination and source buckets
// Inputs are reversed in this module to allow the reverse replication configuration
module "s3_create_destination_replication" {
  source                      = "../modules/aws-s3-replication"
  source_bucket_name_arn      = module.s3_create_destination_bucket.s3_bucket_name_arn
  destination_bucket_name_arn = module.s3_create_source_bucket.s3_bucket_name_arn
  source_bucket_id            = module.s3_create_destination_bucket.s3_bucket_id
  source_kms_key_arn          = var.destination_kms_key_arn
  destination_kms_key_arn     = var.source_kms_key_arn
  source_region               = var.destination_region
  destination_region          = var.source_region
  providers = {
    aws = aws.destination
  }
}

// This module will create a Multi region Access Point for s3 buckets
module "create_mrap" {
  source                     = "../modules/aws-s3-mrap"
  mrap_creation_enabled      = var.mrap_creation_enabled
  source_bucket_name_id      = module.s3_create_source_bucket.s3_bucket_id
  destination_bucket_name_id = module.s3_create_destination_bucket.s3_bucket_id
  source_region              = var.source_region
  destination_region         = var.destination_region
  environment                = var.environment
}