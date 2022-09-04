variable "replication_enabled" {
  type        = bool
  description = "Enable replication"
  default     = true
}

variable "app_name" {
  type        = string
  description = "Application name"
  default     = "app"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "source_bucket_name_arn" {
  type        = string
  description = "Source bucket name ARN"
}

variable "destination_bucket_name_arn" {
  type        = string
  description = "Destination bucket name ARN"
}

variable "source_region" {
  type        = string
  description = "Source region"
}

variable "destination_region" {
  type        = string
  description = "Destination region"
}

variable "source_kms_key_arn" {
  type        = string
  description = "Source KMS key ID"
}

variable "destination_kms_key_arn" {
  type        = string
  description = "Destination KMS key ID"
}

variable "source_bucket_id" {
  type        = string
  description = "Bucket ID to configure the replication at source"
}