######################################################################################
# Cloudtrail
# name rule : trail-[system]-[account]-[env]
######################################################################################

module "cloudtrail" {
  source = "../modules/cloudtrail"

  name                       = format("trail-%s-%s-%s", var.system, var.account, var.env)
  s3_bucket_name             = module.s3_trail.s3_bucket_id
  cloud_watch_logs_role_arn  = module.iam_assumable_role_trail.iam_role_arn
  cloud_watch_logs_group_arn = module.cloudwatch_cloudtrail.cloudwatch_log_group_arn
  kms_key_id                 = module.kms_cloudtrail01.key_arn
  enable_log_file_validation = true
  is_multi_region_trail      = true
  is_organization_trail      = false

  event_selector = [
    {
      read_write_type           = "All"
      include_management_events = true
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    }
  ]
}