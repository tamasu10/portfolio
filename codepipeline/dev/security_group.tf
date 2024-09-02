######################################################################################
# Security Group
# name rule : isg-[system]-[account]-[env]-[component][no2]
######################################################################################
module "sg_ec2_test" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name   = format("isg-%s-%s-%s-test01", var.system, var.account, var.env)
  vpc_id = module.vpc.vpc_id

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}


module "sg_aurora" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name                = format("isg-%s-%s-%s-aurora01", var.system, var.account, var.env)
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["10.100.2.0/24"]
  ingress_rules       = ["mysql-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}

module "sg_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name                = format("isg-%s-%s-%s-rds01", var.system, var.account, var.env)
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["10.100.2.0/24"]
  ingress_rules       = ["mysql-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}