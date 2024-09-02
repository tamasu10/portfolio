######################################################################################
# Network ACL
# name rule : acl-[system]-[account]-[env]
######################################################################################
module "network_acl" {
  source = "../modules/network_acl"

  name   = format("acl-%s-%s-%s", var.system, var.account, var.env)
  vpc_id = module.vpc.vpc_id
  subnet_ids = [
    module.vpc.subnets["public-subnet01-d"].id,
    module.vpc.subnets["private-subnet02-a"].id
  ]
  ingress = [
    {
      protocol   = "all"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]
  egress = [
    {
      protocol   = "all"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]
}
