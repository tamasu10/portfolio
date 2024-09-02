######################################################################################
# Internet Gateway
# name rule: igw-[system]-[account]-[env]-[component]-[region]
######################################################################################
module "internet_gateway" {
  source = "../modules/internet_gateway"

  vpc_id   = module.vpc.vpc_id
  igw_name = format("igw-%s-%s-%s-test-apn1", var.system, var.account, var.env)
}