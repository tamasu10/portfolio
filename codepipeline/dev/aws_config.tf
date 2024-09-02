######################################################################################
# Config
# name rule : config-[system]-[account]-[env]-[component]
######################################################################################

module "aws_config" {
  source = "../modules/aws_config"

  delivery_channel_name = format("config-%s-%s-%s-channel", var.system, var.account, var.env)
  s3_bucket             = module.s3_config.s3_bucket_id
  recorder_name         = format("config-%s-%s-%s-recorder", var.system, var.account, var.env)
  role_arn              = module.iam_assumable_role_config.iam_role_arn
   sns_topic_arn         = module.sns_config.sns_arn
  is_enabled = true
  recording_group = {
    all_supported                 = "true"
    include_global_resource_types = "true"
  }
}