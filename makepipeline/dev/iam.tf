######################################################################################
# IAM policy name rule : policy-[system]-[account]-[env]-[component][no2]
# IAM Role name rule : role-[system]-[account]-[env]-[component][no2]
######################################################################################

######################################################################################
# codepipeline
######################################################################################
module "iam_assumable_role_codepipeline" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  create_role       = true
  role_name         = format("role-%s-%s-%s-codepipeline01", var.system, var.account, var.env)
  role_requires_mfa = false

  trusted_role_actions = [
    "sts:AssumeRole"
  ]
  trusted_role_services = [
    "codepipeline.amazonaws.com"
  ]

  number_of_custom_role_policy_arns = 1
  custom_role_policy_arns = [
    format("arn:aws:iam::%s:policy/policy-%s-%s-%s-codepipeline01", data.aws_caller_identity.current.account_id, var.system, var.account, var.env)
  ]

  create_instance_profile = false

  tags = {
    Name = format("role-%s-%s-%s-codepipeline01", var.system, var.account, var.env)
  }
}

module "iam_policy_codepipeline" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name   = format("policy-%s-%s-%s-codepipeline01", var.system, var.account, var.env)
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_codepipeline01.json
    tags = {
    Name = format("role-%s-%s-%s-codepipeline01", var.system, var.account, var.env)
  }
  }

  data "aws_iam_policy_document" "iam_policy_codepipeline01" {
  source_policy_documents = [
    # data.aws_iam_policy_document.iam_policy_codepipeline_codedeploytoecs.json,
    data.aws_iam_policy_document.iam_policy_codepipeline_codecommit.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_codedeploy.json,
    data.aws_iam_policy_document.iam_policy_codepipeline_codestar.json,
    data.aws_iam_policy_document.iam_policy_codepipeline_elasticbeanstalk.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_lambda.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_opsworks.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_cloudformation_stackset.json,
    data.aws_iam_policy_document.iam_policy_codepipeline_codebuild.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_devicefarm.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_servicecatalog01.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_servicecatalog02.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_ecr.json,  
    # data.aws_iam_policy_document.iam_policy_codepipeline_stepfunction.json,
    # data.aws_iam_policy_document.iam_policy_codepipeline_appconfig.json,
    data.aws_iam_policy_document.iam_policy_codepipeline_s3.json
    ]
  }

  # data "aws_iam_policy_document" "iam_policy_codepipeline_codedeploytoecs" {
  #   statement {
  #           actions = [
  #               "iam:PassRole",
  #           ]
  #           resources = ["*"]
  #           effect = "Allow"
  #           condition {
  #               test      = "StringEqualsIfExists"
  #               variable  = "PassedToService"
  #               values    = [
  #                             "cloudformation.amazonaws.com",
  #                             "elasticbeanstalk.amazonaws.com",
  #                             "ec2.amazonaws.com",
  #                             "ecs-tasks.amazonaws.com",
  #                           ]
  #               }
  #           }
  #       }

  data "aws_iam_policy_document" "iam_policy_codepipeline_codecommit" {
    statement {
            actions = [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetRepository",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ]
            resources = ["*"]
            effect = "Allow"
        }
    }

  # data "aws_iam_policy_document" "iam_policy_codepipeline_codedeploy" {
  #   statement {
  #           actions = [
  #               "codedeploy:CreateDeployment",
  #               "codedeploy:GetApplication",
  #               "codedeploy:GetApplicationRevision",
  #               "codedeploy:GetDeployment",
  #               "codedeploy:GetDeploymentConfig",
  #               "codedeploy:RegisterApplicationRevision"
  #           ]
  #           resources = ["*"]
  #           effect = "Allow"
  #       }
  #   }

  data "aws_iam_policy_document" "iam_policy_codepipeline_codestar" {
    statement {
            actions = [
                "codestar-connections:UseConnection"
            ]
            resources = ["*"]
            effect = "Allow"
        }
  }

  data "aws_iam_policy_document" "iam_policy_codepipeline_elasticbeanstalk" {
    statement  {
            actions = [
                "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
            ]
            resources = ["*"]
            effect = "Allow"
        }
  }

  # data "aws_iam_policy_document" "iam_policy_codepipeline_lambda" {
  #   statement {
  #           actions = [
  #               "lambda:InvokeFunction",
  #               "lambda:ListFunctions"
  #           ]
  #           resources = ["*"]
  #           effect = "Allow"
  #       }
  # }

  # data "aws_iam_policy_document" "iam_policy_codepipeline_opsworks" {
  #   statement {
  #           actions = [
  #               "opsworks:CreateDeployment",
  #               "opsworks:DescribeApps",
  #               "opsworks:DescribeCommands",
  #               "opsworks:DescribeDeployments",
  #               "opsworks:DescribeInstances",
  #               "opsworks:DescribeStacks",
  #               "opsworks:UpdateApp",
  #               "opsworks:UpdateStack"
  #           ]
  #           resources = ["*"]
  #           effect = "Allow"
  #       }
  # }
  
  # data "aws_iam_policy_document" "iam_policy_codepipeline_cloudformation_stackset" {
  #   statement {
  #           actions = [
  #               "cloudformation:CreateStack",
  #               "cloudformation:DeleteStack",
  #               "cloudformation:DescribeStacks",
  #               "cloudformation:UpdateStack",
  #               "cloudformation:CreateChangeSet",
  #               "cloudformation:DeleteChangeSet",
  #               "cloudformation:DescribeChangeSet",
  #               "cloudformation:ExecuteChangeSet",
  #               "cloudformation:SetStackPolicy",
  #               "cloudformation:ValidateTemplate"
  #           ]
  #           resources = ["*"]
  #           effect = "Allow"
  #       }
  # }
  
  data "aws_iam_policy_document" "iam_policy_codepipeline_codebuild"{
    statement {
            actions = [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ]
            resources = ["*"]
            effect = "Allow"
        }
  }

  # data "aws_iam_policy_document" "iam_policy_codepipeline_devicefarm"{
  #   statement {
  #           effect = "Allow"
  #           actions = [
  #               "devicefarm:ListProjects",
  #               "devicefarm:ListDevicePools",
  #               "devicefarm:GetRun",
  #               "devicefarm:GetUpload",
  #               "devicefarm:CreateUpload",
  #               "devicefarm:ScheduleRun"
  #           ]
  #           resources = ["*"]
  #       }
  # }

  # data "aws_iam_policy_document" "iam_policy_codepipeline_servicecatalog01"{
  #   statement {
  #           effect = "Allow"
  #           actions = [
  #               "servicecatalog:ListProvisioningArtifacts",
  #               "servicecatalog:CreateProvisioningArtifact",
  #               "servicecatalog:DescribeProvisioningArtifact",
  #               "servicecatalog:DeleteProvisioningArtifact",
  #               "servicecatalog:UpdateProduct"
  #           ]
  #           resources = ["*"]
  #       }
  # }
  
  # data "aws_iam_policy_document" "iam_policy_codepipeline_servicecatalog02"{
  #   statement {
  #           effect = "Allow"
  #           actions = [
  #               "cloudformation:ValidateTemplate"
  #           ]
  #           resources = ["*"]
  #       }
  # }

  data "aws_iam_policy_document" "iam_policy_codepipeline_ecr"{
    statement {
            effect = "Allow"
            actions = [
                "ecr:DescribeImages"
            ]
            resources = ["*"]
        }
  }

  # data "aws_iam_policy_document" "iam_policy_codepipeline_stepfunction"{
  #   statement {
  #           effect = "Allow"
  #           actions = [
  #               "states:DescribeExecution",
  #               "states:DescribeStateMachine",
  #               "states:StartExecution"
  #           ]
  #           resources = ["*"]
  #       }
  # }
  
  # data "aws_iam_policy_document" "iam_policy_codepipeline_appconfig"{
  #   statement {
  #           effect = "Allow"
  #           actions = [
  #               "appconfig:StartDeployment",
  #               "appconfig:StopDeployment",
  #               "appconfig:GetDeployment"
  #           ]
  #           resources = ["*"]
  #       }
  # }

  data "aws_iam_policy_document" "iam_policy_codepipeline_s3"{
    statement {
            effect = "Allow"
            actions = [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
            resources = [
              "arn:aws:s3:::aap-template-account-dev-codepipeline",
              "arn:aws:s3:::aap-template-account-dev-codepipeline/*",
              "arn:aws:s3:::aap-template-account-dev-codepipeline-artifact",
              "arn:aws:s3:::aap-template-account-dev-codepipeline-artifact/*"
            ]
        }
  }

######################################################################################
# codebuild
######################################################################################
module "iam_assumable_role_codebuild" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  create_role       = true
  role_name         = format("role-%s-%s-%s-codebuild01", var.system, var.account, var.env)
  role_requires_mfa = false

  trusted_role_actions = [
    "sts:AssumeRole"
  ]
  trusted_role_services = [
    "codebuild.amazonaws.com"
  ]

  number_of_custom_role_policy_arns = 1
  custom_role_policy_arns = [
    # format("arn:aws:iam::%s:policy/policy-%s-%s-%s-codebuild01", var.account_id, var.system, var.account, var.env),
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]

  create_instance_profile = false

  tags = {
    Name = format("role-%s-%s-%s-codebuild01", var.system, var.account, var.env)
  }
}

# module "iam_policy_codebuild" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "4.1.0"

#   name   = format("policy-%s-%s-%s-codebuild01", var.system, var.account, var.env)
#   path   = "/"
#   policy = data.aws_iam_policy_document.iam_policy_codebuild01.json
# }

# data "aws_iam_policy_document" "iam_policy_codebuild01" {
#   source_policy_documents = [
#     data.aws_iam_policy_document.iam_policy_codebuild_logs.json,
#     data.aws_iam_policy_document.iam_policy_codebuild_s3.json
#   ]
#   }

# data "aws_iam_policy_document" "iam_policy_codebuild_logs"{
#     statement {
#             effect = "Allow"
#             actions = [
#               "logs:CreateLogGroup",
#               "logs:CreateLogStream",
#               "logs:PutLogEvents"
#             ]
#             resources = ["*"]
#         }
#   }

#   data "aws_iam_policy_document" "iam_policy_codebuild_s3"{
#     statement {
#             effect = "Allow"
#             actions = [
#                 "s3:PutObject",
#                 "s3:GetObject",
#                 "s3:GetObjectVersion",
#                 "s3:GetBucketAcl",
#                 "s3:GetBucketLocation"
#             ]
#             resources = [
#               "arn:aws:s3:::aap-template-account-dev-codepipeline",
#               "arn:aws:s3:::aap-template-account-dev-codepipeline/*",
#               "arn:aws:s3:::aap-template",
#               "arn:aws:s3:::aap-template/*"
#             ]
#         }
#   }