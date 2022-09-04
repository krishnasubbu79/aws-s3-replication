output "s3_mrap" {
  value = module.create_mrap.s3_mrap_arn
}

output "s3_source_bucket_arn" {
  value = module.s3_create_source_bucket.s3_bucket_name_arn
}

output "s3_destination_bucket_arn" {
  value = module.s3_create_destination_bucket.s3_bucket_name_arn
}
