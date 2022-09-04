output "s3_mrap_arn" {
  value = element(concat(aws_s3control_multi_region_access_point.s3_mrap.*.arn, tolist([""])), 0)
}
