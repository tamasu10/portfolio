######################################################################################
# S3 bucket
# name rule : [system]-[account]-[env]-[component]
######################################################################################

######################################################################################
# codepipeline
######################################################################################
module "s3_codepipeline_artifact" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.2.0"

  bucket                  = format("%s-%s-%s-codepipeline-artifact", var.system, var.account ,var.env)
  acl                     = "private"
  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  attach_policy           = false
  #   policy                  = data.aws_iam_policy_document.s3_codepipeline.json
  versioning = {
    enabled = true
  }
  #   logging = {
  #     target_bucket = format(var.s3buckets["codepipeline"].logging.target_bucket, var.project, var.env)
  #   }
  #   server_side_encryption_configuration = {
  #     rule = {
  #       apply_server_side_encryption_by_default = {
  #         kms_master_key_id = module.kms_codepipeline.key_arn
  #         sse_algorithm     = var.s3buckets["codepipeline"].server_side_encryption_configuration.sse_algorithm
  #       }
  #     }
  #   }
    tags = {
    Name = format("%s-%s-%s-codepipeline_artifact", var.system, var.account ,var.env)
  }
}