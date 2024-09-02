######################################################################################
# sns
# name rule : sns-[system]-[account]-[env]-[component]
######################################################################################

module "sns_apply" {
  source  = "../modules/sns"

  name                              = format("sns-%s-%s-%s-apply", var.system, var.account, var.env)
  fifo_topic                        = false
  display_name                      = format("sns-%s-%s-%s-apply", var.system, var.account, var.env)
  kms_master_key_id                 = "alias/aws/sns"
#   policy                            = var.sns.policy 
#   delivery_policy                   = var.sns.delivery_policy
  http_success_feedback_sample_rate = 100
  protocol                          = "email"
  endpoint                          = "subaru.takemoto@ariseanalytics.com"
}