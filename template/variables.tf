// All the public block variables will default to true
variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Enable public access to s3 buckets"
}

variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Enable public policy on s3 buckets"
}

variable "ignore_public_acls" {
  type        = bool
  default     = true
  description = "Ignore public acls on s3 buckets"
}

variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Restrict public access to s3 buckets"
}

variable "s3_source_bucket_creation_enabled" {
  type        = bool
  default     = true
  description = "Enable s3 bucket creation at the source region"
}

variable "s3_destination_bucket_creation_enabled" {
  type        = bool
  default     = true
  description = "Enable s3 bucket creation at the destination region"
}

variable "environment" {
  type        = string
  default     = "development"
  description = "Environment"
}

variable "app_name" {
  type        = string
  default     = "app"
  description = "Application name"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name"
}

variable "source_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region"
}

variable "s3_bucket_replication_enabled" {
  type        = bool
  default     = false
  description = "Enable s3 bucket replication"
}

variable "source_enable_backup" {
  type        = bool
  default     = true
  description = "Enable backup"
}

variable "destination_enable_backup" {
  type        = bool
  default     = false
  description = "Enable backup"
}

variable "enable_versioning" {
  type        = string
  default     = "Enabled"
  description = "Enable versioning"
}

variable "source_log_bucket" {
  type        = string
  description = "Source log bucket"
}

variable "destination_log_bucket" {
  type        = string
  description = "Destination log bucket"
}

variable "s3_lifecycle_rules" {
  type        = list(any)
  description = "S3 lifecycle rules"
}

variable "source_kms_key_arn" {
  type        = string
  description = "Source kms key arn"
}

variable "destination_kms_key_arn" {
  type        = string
  description = "Destination kms key arn"
}

variable "destination_region" {
  type        = string
  default     = "ap-east-1"
  description = "Destination region"
}

variable "kms_source_logging_arn" {
  type        = string
  description = "Kms Source logging arn"
}

variable "kms_destination_logging_arn" {
  type        = string
  description = "Kms destination logging arn"
}

variable "s3_source_log_bucket_creation_enabled" {
  type        = bool
  default     = true
  description = "Enable s3 log bucket creation at the source region"
}

variable "enable_logbucket_versioning" {
  type        = string
  default     = "Enabled"
  description = "Enable versioning"
}

variable "source_logbucket_enable_backup" {
  type        = bool
  default     = false
  description = "Enable backup"
}

variable "destination_logbucket_enable_backup" {
  type        = bool
  default     = false
  description = "Enable backup"
}

variable "s3_destination_log_bucket_creation_enabled" {
  type        = bool
  default     = false
  description = "Enable s3 log bucket creation at the destination region"
}

variable "mrap_creation_enabled" {
  type        = bool
  default     = true
  description = "Enable mrap creation"
}