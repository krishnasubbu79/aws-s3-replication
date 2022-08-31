environment                            = "prod"
app_name                               = "app"
s3_source_bucket_creation_enabled      = true
bucket_name                            = "app-dev-testing-s3-repl"
source_region                          = "eu-west-1"
destination_region                     = "ap-south-1"
source_enable_backup                   = true
destination_enable_backup              = false
s3_destination_bucket_creation_enabled = false
s3_lifecycle_rules                     = []
source_kms_key_arn                     = "arn:aws:kms:eu-west-1:227310848243:key/befc6867-06ca-4d30-981b-3c1db2659bea"
destination_kms_key_arn                = "arn:aws:kms:ap-south-1:227310848243:key/05d06ab0-3a95-40f0-9c9b-5cbf1fc39a80"
source_log_bucket                      = "mylogsbucket-testing"
destination_log_bucket                 = "mylogsbucket-testing-ap-south-1"
s3_bucket_replication_enabled          = false


