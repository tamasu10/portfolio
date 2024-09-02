######################################################################################
# Cloudwatch
######################################################################################
module "cloudwatch_cloudtrail" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "2.1.0"

  # kms_key_id = module.kms_trail.key_arn
  name = format("/aap/%s/%s/%s/trail", var.system, var.account, var.env)
  # cloudwatch_log_stream_name  = format(var.cloudwatch.log_stream_name, var.account_id, var.region)
}