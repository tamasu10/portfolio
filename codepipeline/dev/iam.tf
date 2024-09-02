######################################################################################
# IAM Group
# name rule : group-[system]-[account]-[env]-[component]
# please attach users
######################################################################################
module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 4.3"

  name = format("group-%s-%s-%s-poweruser", var.system, var.account, var.env)
  attach_iam_self_management_policy = true
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess",
  ]
   tags = {
    Name = format("group-%s-%s-%s-poweruser", var.system, var.account, var.env)
  }
}
######################################################################################
# IAM policy name rule : policy-[system]-[account]-[env]-[component][no2]
# IAM Role name rule : role-[system]-[account]-[env]-[component][no2]
######################################################################################

######################################################################################
# ssm
######################################################################################

module "iam_assumable_role_ssm" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.3"

  create_role       = true
  role_name         = format("role-%s-%s-%s-ssm01", var.system, var.account, var.env)
  role_requires_mfa = false

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  number_of_custom_role_policy_arns = 2
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  create_instance_profile = true

  tags = {
    Name = format("role-%s-%s-%s-ssm01", var.system, var.account, var.env)
  }
}

######################################################################################
# flowlogs
######################################################################################

module "iam_assumable_role_flowlogs" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  create_role       = true
  role_name         = format("role-%s-%s-%s-flowlogs01", var.system, var.account, var.env)
  role_requires_mfa = false

  trusted_role_services = [
    "vpc-flow-logs.amazonaws.com"
  ]

  number_of_custom_role_policy_arns = 1
  custom_role_policy_arns = [
    format("arn:aws:iam::%s:policy/policy-%s-%s-%s-flowlogs01", data.aws_caller_identity.current.account_id, var.system, var.account, var.env)
  ]

  create_instance_profile = true

  tags = {
    Name = format("role-%s-%s-%s-flowlogs01", var.system, var.account, var.env)
  }
}

module "iam_policy_flowlogs" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name   = format("policy-%s-%s-%s-flowlogs01", var.system, var.account, var.env)
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_flowlogs.json

  tags = {
    Name = format("policy-%s-%s-%s-flowlogs01", var.system, var.account, var.env)
  }
}

data "aws_iam_policy_document" "iam_policy_flowlogs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

######################################################################################
# Config
######################################################################################

module "iam_assumable_role_config" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.3"

  create_role       = true
  role_name         = format("role-%s-%s-%s-config01", var.system, var.account, var.env)
  role_requires_mfa = false

  trusted_role_services = [
    "config.amazonaws.com"
  ]

  number_of_custom_role_policy_arns = 2
  custom_role_policy_arns = [
    format("arn:aws:iam::%s:policy/policy-%s-%s-%s-config01", data.aws_caller_identity.current.account_id, var.system, var.account, var.env),
    "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
  ]

  create_instance_profile = true

  tags = {
    Name = format("role-%s-%s-%s-config01", var.system, var.account, var.env)
  }
}


module "iam_policy_config" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name   = format("policy-%s-%s-%s-config01", var.system, var.account, var.env)
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_config.json


  tags = {
    Name = format("policy-%s-%s-%s-config01", var.system, var.account, var.env)
  }
}

data "aws_iam_policy_document" "iam_policy_config" {
  source_policy_documents = [
    data.aws_iam_policy_document.iam_policy_config_s3put.json,
    data.aws_iam_policy_document.iam_policy_config_s3get.json
  ]
}

data "aws_iam_policy_document" "iam_policy_config_s3put" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      format("arn:aws:s3:::%s-%s-%s-config/AWSLogs/%s/*", var.system, var.account, var.env, data.aws_caller_identity.current.account_id)
    ]
    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

data "aws_iam_policy_document" "iam_policy_config_s3get" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      format("arn:aws:s3:::%s-%s-%s-config/AWSLogs/%s/*", var.system, var.account, var.env, data.aws_caller_identity.current.account_id)
    ]
  }
}


# ######################################################################################
# # kmsmanage
# ######################################################################################
# module "iam_assumable_role_kmsmanage" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "4.1.0"

#   create_role       = true
#   role_name         = format("role-%s-%s-%s-kmsmanage01",var.system, var.account,var.env)
#   role_requires_mfa = false

#   trusted_role_services = [
#     "ec2.amazonaws.com"
#   ]

#   create_instance_profile = false

#   tags = {
#     Name = format("role-%s-%s-%s-kmsmanage01",var.system, var.account,var.env)
#   }
# }

# ######################################################################################
# # kmsaccess
# ######################################################################################
# module "iam_assumable_role_kmsaccess" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "4.1.0"

#   create_role       = true
#   role_name         = format("role-%s-%s-%s-kmsaccess01",var.system, var.account,var.env)
#   role_requires_mfa = false

#   trusted_role_services = [
#     "ec2.amazonaws.com"
#   ]

#   create_instance_profile = false

#   tags = {
#     Name = format("role-%s-%s-%s-kmsaccess01",var.system, var.account,var.env)
#   }
# }


######################################################################################
# trail
######################################################################################

module "iam_assumable_role_trail" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  create_role       = true
  role_name         = format("role-%s-%s-%s-trail01", var.system, var.account, var.env)
  role_requires_mfa = false

  trusted_role_services = [
    "cloudtrail.amazonaws.com"
  ]

  number_of_custom_role_policy_arns = 1
  custom_role_policy_arns = [
    format("arn:aws:iam::%s:policy/policy-%s-%s-%s-cloudtrail01", data.aws_caller_identity.current.account_id, var.system, var.account, var.env)
  ]

  create_instance_profile = false

  tags = {
    Name = format("role-%s-%s-%s-trail01", var.system, var.account, var.env)
  }
}

module "iam_policy_trail" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name   = format("policy-%s-%s-%s-cloudtrail01", var.system, var.account, var.env)
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_trail.json
  tags = {
    Name = format("policy-%s-%s-%s-cloudtrail01", var.system, var.account, var.env)
  }
}

data "aws_iam_policy_document" "iam_policy_trail" {
  source_policy_documents = [
    data.aws_iam_policy_document.iam_policy_trail_aws_cloudtrail__create_log_stream2014110.json,
    data.aws_iam_policy_document.iam_policy_trail_aws_cloudtrail_put_log_events20141101.json
  ]
}

data "aws_iam_policy_document" "iam_policy_trail_aws_cloudtrail__create_log_stream2014110" {
  statement {
    sid    = "AWSCloudTrailCreateLogStream2014110"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream"
    ]
    resources = [
      format(
        "arn:aws:logs:%s:%s:log-group:%s:log-stream:%s_CloudTrail_%s*",
        var.region,
        data.aws_caller_identity.current.account_id,
        module.cloudwatch_cloudtrail.cloudwatch_log_group_name,
        data.aws_caller_identity.current.account_id,
        var.region
      )
    ]
  }
}

data "aws_iam_policy_document" "iam_policy_trail_aws_cloudtrail_put_log_events20141101" {
  statement {
    sid    = "AWSCloudTrailPutLogEvents20141101"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      format(
        "arn:aws:logs:%s:%s:log-group:%s:log-stream:%s_CloudTrail_%s*",
        var.region,
        data.aws_caller_identity.current.account_id,
        module.cloudwatch_cloudtrail.cloudwatch_log_group_name,
        data.aws_caller_identity.current.account_id,
        var.region
      )
    ]
  }
}
