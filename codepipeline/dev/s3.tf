######################################################################################
# S3 bucket
# name rule : [system]-[account]-[env]-[component]
######################################################################################

######################################################################################
# Config
######################################################################################
module "s3_config" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"

  bucket                  = format("%s-%s-%s-config", var.system, var.account, var.env)
  acl                     = "private"
  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  attach_policy           = true
  policy                  = data.aws_iam_policy_document.s3_config.json
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name = format("%s-%s-%s-config", var.system, var.account, var.env)
  }
}


data "aws_iam_policy_document" "s3_config" {
  source_policy_documents = [
    data.aws_iam_policy_document.bucket_policy_config_aws_config_bucket_permissions_check.json,
    data.aws_iam_policy_document.bucket_policy_config_aws_config_bucket_existence_check.json,
    data.aws_iam_policy_document.bucket_policy_config_aws_config_bucket_delivery.json
  ]
}

data "aws_iam_policy_document" "bucket_policy_config_aws_config_bucket_permissions_check" {
  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [format("arn:aws:s3:::%s-%s-%s-config", var.system, var.account, var.env)]
  }
}

data "aws_iam_policy_document" "bucket_policy_config_aws_config_bucket_existence_check" {
  statement {
    sid    = "AWSConfigBucketExistenceCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions   = ["s3:ListBucket"]
    resources = [format("arn:aws:s3:::%s-%s-%s-config", var.system, var.account, var.env)]
  }
}

data "aws_iam_policy_document" "bucket_policy_config_aws_config_bucket_delivery" {
  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = [format("arn:aws:s3:::%s-%s-%s-config/AWSLogs/%s/Config/*", var.system, var.account, var.env, data.aws_caller_identity.current.account_id)]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

######################################################################################
# cloud trail
######################################################################################
module "s3_trail" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"

  bucket                  = format("%s-%s-%s-trail", var.system, var.account, var.env)
  acl                     = "private"
  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  attach_policy           = true
  policy                  = data.aws_iam_policy_document.s3_trail.json
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms_trail01.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = {
    Name = format("%s-%s-%s-trail", var.system, var.account, var.env)
  }
}

data "aws_iam_policy_document" "s3_trail" {
  source_policy_documents = [
    data.aws_iam_policy_document.bucket_policy_trail_aws_cloud_trail_acl_check_20150319.json,
    data.aws_iam_policy_document.bucket_policy_trail_aws_cloud_trail_write_20150319.json
  ]
}

data "aws_iam_policy_document" "bucket_policy_trail_aws_cloud_trail_acl_check_20150319" {
  statement {
    sid    = "AWSCloudTrailAclCheck20150319"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["s3:GetBucketAcl"]
    resources = [
      format("arn:aws:s3:::%s-%s-%s-trail", var.system, var.account, var.env)
    ]
  }
}

data "aws_iam_policy_document" "bucket_policy_trail_aws_cloud_trail_write_20150319" {
  statement {
    sid    = "AWSCloudTrailWrite20150319"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = [format("arn:aws:s3:::%s-%s-%s-trail/*", var.system, var.account, var.env)]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

