######################################################################################
# VPC-endpoint
# name rule : endpoint-[aws service]-[system]-[account]-[env]
######################################################################################

module "vpc-endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.11.0"

  vpc_id = module.vpc.vpc_id
  endpoints = {
    s3 = {
      service             = "s3"
      private_dns_enabled = false
      policy              = data.aws_iam_policy_document.vpc_endpoint_policy_s3.json
      security_group_ids  = [module.sg_ec2_test.security_group_id]
      tags                = { Name = format("endpoint-s3-%s-%s-%s", var.system, var.account, var.env) }
    }
  }
}

data "aws_iam_policy_document" "vpc_endpoint_policy_s3" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["*"]
    resources = ["*"]
  }
}