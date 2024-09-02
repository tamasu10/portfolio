######################################################################################
# codecommit
# name rule : codecommit-[system]-[account]-[env]-[component]
######################################################################################
module "codecommit_codepipeline" {
  source = "../modules/codecommit"

  repository_name = format("codecommit-%s-%s-%s-codepipeline", var.system, var.account, var.env)
}