######################################################################################
# codepipeline
# name rule : [system]-[account]-[env]
######################################################################################
module "codepipeline" {
  source = "../modules/codepipeline"

  codepipeline_name       = format("%s-%s-%s", var.system, var.account, var.env)
  role_arn                = module.iam_assumable_role_codepipeline.iam_role_arn
  artifact_store_location = module.s3_codepipeline_artifact.s3_bucket_id
  artifact_store_type     = "S3"
  stage                   = [
      {
        name = "Source"
        action = [{
          run_order        = 1
          name             = "Source"
          category         = "Source"
          owner            = "AWS"
          provider         = "CodeCommit"
          version          = "1"
          output_artifacts = ["source_output"]
          configuration = {
            RepositoryName = module.codecommit_codepipeline.repository_name
            BranchName     = "main"
          }
        }]
      },
      {
        name = "Build"
        action = [{
          run_order       = 2
          name            = "Build"
          category        = "Build"
          owner           = "AWS"
          provider        = "CodeBuild"
          version         = "1"
          input_artifacts = ["source_output"]
          configuration = {
            ProjectName = format("%s-%s-%s-codebuild-plan", var.system, var.account, var.env)
          }
        }]
      },
      {
        name = "Approval"
        action = [{
          run_order = 3
          name      = "Approval"
          category  = "Approval"
          owner     = "AWS"
          provider  = "Manual"
          version   = "1"
          configuration = {
            NotificationArn = "arn:aws:sns:ap-northeast-1:723349266634:sns-aap-template-account-dev-apply"
            # CustomData = "${var.approve_comment}"
            # ExternalEntityLink = "${var.approve_url}"
          }
        }]
      },
      {
        name = "Apply"
        action = [{
          run_order       = 4
          name            = "Apply"
          category        = "Build"
          owner           = "AWS"
          provider        = "CodeBuild"
          version         = "1"
          input_artifacts = ["source_output"]
          configuration = {
            ProjectName = format("%s-%s-%s-codebuild-apply", var.system, var.account, var.env)
          }
        }]
}
]
}