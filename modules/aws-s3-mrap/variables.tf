variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment to deploy into"
}

variable "source_region" {
  type        = string
  description = "The source region for the replication"
}

variable "destination_region" {
  type        = string
  description = "The destination region for the replication"
}

variable "source_bucket_name_id" {
  type        = string
  description = "The name of the source bucket ID"
}

variable "destination_bucket_name_id" {
  type        = string
  description = "The name of the destination bucket ID"
}

variable "mrap_creation_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable the creation of the MRAP"
}