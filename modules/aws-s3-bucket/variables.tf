variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Whether to block public access to the s3 bucket"
}

variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Block public policy"
}

variable "ignore_public_acls" {
  type        = bool
  default     = true
  description = "Ignore public acls"
}

variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Restrict public buckets to be read-only"
}

variable "s3_bucket_creation_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable S3 bucket creation"
}

variable "environment" {
  type        = string
  description = "The environment to deploy to"
}

variable "app_name" {
  type        = string
  description = "The name of the application"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
}


variable "tags" {
  type        = map(string)
  description = "Tags to apply to the S3 bucket"
}

variable "enable_backup" {
  type    = bool
  default = true
}

variable "versioning_status" {
  type        = string
  default     = "Enabled"
  description = "The versioning status of the S3 bucket"
}

variable "log_bucket" {
  type        = string
  description = "The name of the S3 bucket to store logs"
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key to use for encryption of s3 bucket"
}

variable "s3_lifecycle_rules" {
  type        = list(string)
  description = "The S3 lifecycle rules to apply to the S3 bucket"
}

variable "logging_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable logging"
}