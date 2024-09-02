######################################################################################
# kms
# name rule : kms-[system]-[account]-[env]-[component][no2]
######################################################################################
######################################################################################
# trail
######################################################################################
module "kms_trail01" {
  source = "../modules/kms"

  key_name       = format("kms-%s-%s-%s-trail01", var.system, var.account, var.env)
  key_alias_name = format("alias/kms-%s-%s-%s-trail01", var.system, var.account, var.env)
  policy         = data.aws_iam_policy_document.trail01.json
}

data "aws_iam_policy_document" "trail01" {
  source_policy_documents = [
    data.aws_iam_policy_document.kms_policy_trail_enable_iam_user_permissions.json,
    # data.aws_iam_policy_document.kms_policy_trail_allowaccess_for_key_administrators.json,
    # data.aws_iam_policy_document.kms_policy_trail_allow_use_of_the_key.json,
    # data.aws_iam_policy_document.kms_policy_trail_allow_attahment_of_persistent_resources.json
  ]
}

data "aws_iam_policy_document" "kms_policy_trail_enable_iam_user_permissions" {
  statement {
    sid    = "EnableIAMUserPermissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

# data "aws_iam_policy_document" "kms_policy_trail_allowaccess_for_key_administrators" {
#   statement {	
#     sid = "AllowAccessForKeyAdministrators"
#     effect = "Allow"
#     principals {	
#       type = "AWS"
#       identifiers = [
#         format("arn:aws:iam::%s:role/role-%s-%s-%s-kmsmanage01", data.aws_caller_identity.current.account_id, var.system, var.account,var.env)
#       ]	
#     }	
#     actions = [	
#       "kms:Update*",	
#       "kms:UntagResource",	
#       "kms:TagResource",	
#       "kms:ScheduleKeyDeletion",	
#       "kms:Revoke*",	
#       "kms:Put*",	
#       "kms:List*",	
#       "kms:Get*",	
#       "kms:Enable*",	
#       "kms:Disable*",	
#       "kms:Describe*",	
#       "kms:Delete*",	
#       "kms:Create*",	
#       "kms:CancelKeyDeletion"	
#     ]
#     resources = ["*"]	
#   }
# }

# data "aws_iam_policy_document" "kms_policy_trail_allow_use_of_the_key" {
#   statement {	
#     sid = "AllowUseOfTheKey"
#     effect = "Allow"
#     principals {	
#       type = "Service"
#       identifiers = ["cloudtrail.amazonaws.com"]	
#     }
#     principals {	
#       type = "AWS"
#       identifiers = [
#         format("arn:aws:iam::%s:role/role-%s-%s-%s-kmsaccess01", data.aws_caller_identity.current.account_id, var.system, var.account,var.env)
#       ]	
#     }
#     actions = [	
#       "kms:ReEncrypt*",	
#       "kms:GenerateDataKey*",	
#       "kms:Encrypt",	
#       "kms:DescribeKey",	
#       "kms:Decrypt",	
#       "kms:CancelKeyDeletion"	
#     ]
#     resources = ["*"]	
#   }
# }

# data "aws_iam_policy_document" "kms_policy_trail_allow_attahment_of_persistent_resources" {
#   statement {	
#     sid = "AllowAttahmentOfPersistentResources"
#     effect = "Allow"
#     principals {	
#       type = "AWS"
#       identifiers = [
#         format("arn:aws:iam::%s:role/role-%s-%s-%s-kmsaccess01", data.aws_caller_identity.current.account_id, var.system, var.account,var.env)
#       ]
#     }
#     actions = [	
#       "kms:RevokeGrant",	
#       "kms:ListGrants",	
#       "kms:CreateGrant"	
#     ]	
#     resources = ["*"]	
#     condition {
#       test = "Bool"
#       variable = "kms:GrantIsForAWSResource"
#       values = ["true"]	
#     }	
#   }
# }


######################################################################################
# cloudtrail
######################################################################################
module "kms_cloudtrail01" {
  source = "../modules/kms"

  key_name       = format("kms-%s-%s-%s-cloudtrail01", var.system, var.account, var.env)
  key_alias_name = format("alias/kms-%s-%s-%s-cloudtrail01", var.system, var.account, var.env)
  policy         = data.aws_iam_policy_document.cloudtrail01.json
}

data "aws_iam_policy_document" "cloudtrail01" {
  source_policy_documents = [
    data.aws_iam_policy_document.kms_policy_cloudtrail_enable_iam_user_permissions.json,
    data.aws_iam_policy_document.kms_policy_cloudtrail_allow_cloudtrail_to_encrypt_logs.json,
    data.aws_iam_policy_document.kms_policy_cloudtrail_allow_cloudtrail_to_describe_key.json,
    data.aws_iam_policy_document.kms_policy_cloudtrail_allow_principals_in_the_account_to_decrypt_log_files.json,
    data.aws_iam_policy_document.kms_policy_cloudtrail_allow_alias_creation_during_setup.json,
    data.aws_iam_policy_document.kms_policy_cloudtrail_enable_cross_account_log_decryption.json
  ]
}

data "aws_iam_policy_document" "kms_policy_cloudtrail_enable_iam_user_permissions" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
        # ,
        # format("arn:aws:iam::%s:user/*", data.aws_caller_identity.current.account_id)
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "kms_policy_cloudtrail_allow_cloudtrail_to_encrypt_logs" {
  statement {
    sid    = "Allow CloudTrail to encrypt logs"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [format("arn:aws:cloudtrail:*:%s:trail/*", data.aws_caller_identity.current.account_id)]
    }
  }
}

data "aws_iam_policy_document" "kms_policy_cloudtrail_allow_cloudtrail_to_describe_key" {
  statement {
    sid    = "Allow CloudTrail to describe key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["kms:DescribeKey"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "kms_policy_cloudtrail_allow_principals_in_the_account_to_decrypt_log_files" {
  statement {
    sid    = "Allow principals in the account to decrypt log files"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [format("arn:aws:cloudtrail:*:%s:trail/*", data.aws_caller_identity.current.account_id)]
    }
  }
}

data "aws_iam_policy_document" "kms_policy_cloudtrail_allow_alias_creation_during_setup" {
  statement {
    sid    = "Allow alias creation during setup"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:CreateAlias"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = [format("ec2.%s.amazonaws.com", var.region)]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "kms_policy_cloudtrail_enable_cross_account_log_decryption" {
  statement {
    sid    = "Enable cross account log decryption"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [format("arn:aws:cloudtrail:*:%s:trail/*", data.aws_caller_identity.current.account_id)]
    }
  }
}
