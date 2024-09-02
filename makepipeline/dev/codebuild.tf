######################################################################################
# codebuild
# name rule : [system]-[account]-[env]-[component]
######################################################################################
module "codebuild_plan" {
  source = "../modules/codebuild"

  codebuild_name              = format("%s-%s-%s-codebuild-plan", var.system, var.account, var.env)
  service_role                = module.iam_assumable_role_codebuild.iam_role_arn
  artifacts_type              = "NO_ARTIFACTS"
  environment                 = [
                                  {
                                    compute_type                = "BUILD_GENERAL1_SMALL"
                                    image                       = "723349266634.dkr.ecr.ap-northeast-1.amazonaws.com/terraform:tag"
                                    type                        = "LINUX_CONTAINER"
                                    image_pull_credentials_type = "CODEBUILD"
                                    environment_variable = [
                                      {
                                        name  = "TF_CMD"
                                        value = "plan"
                                      },
                                      {
                                        name  = "TF_OPT"
                                        value = "-input=false -no-color"
                                      }
                                    ]
                                  }
                                ]
  cloudwatch_logs_group_name  = format("%s-%s-%s-log", var.system, var.account, var.env)
  cloudwatch_logs_stream_name = format("%s-%s-%s-log-stream", var.system, var.account, var.env)
  source_type                 = "CODECOMMIT"
  source_location             = module.codecommit_codepipeline.repository_name
  source_version              = "main"
  
}

module "codebuild_apply" {
  source = "../modules/codebuild"

  codebuild_name              = format("%s-%s-%s-codebuild-apply", var.system, var.account, var.env)
  service_role                = module.iam_assumable_role_codebuild.iam_role_arn
  artifacts_type              = "NO_ARTIFACTS"
  environment                 = [
                                  {
                                    compute_type                = "BUILD_GENERAL1_SMALL"
                                    image                       = "723349266634.dkr.ecr.ap-northeast-1.amazonaws.com/terraform:tag"
                                    type                        = "LINUX_CONTAINER"
                                    image_pull_credentials_type = "CODEBUILD"
                                    environment_variable = [
                                      {
                                        name  = "TF_CMD"
                                        value = "apply"
                                      },
                                      {
                                        name  = "TF_OPT"
                                        value = "-input=false -auto-approve -no-color"
                                      }
                                    ]
                                  }
                                ]
  cloudwatch_logs_group_name  = format("%s-%s-%s-log", var.system, var.account, var.env)
  cloudwatch_logs_stream_name = format("%s-%s-%s-log-stream", var.system, var.account, var.env)
  source_type                 = "CODECOMMIT"
  source_location             = module.codecommit_codepipeline.repository_name
  source_version              = "main"
}