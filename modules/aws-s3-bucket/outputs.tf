output "s3_bucket_name_arn" {
  value = element(concat(aws_s3_bucket.bucket.*.arn, tolist([""])), 0)
}

output "s3_bucket_id" {
  value = element(concat(aws_s3_bucket.bucket.*.id, tolist([""])), 0)
}