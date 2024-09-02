######################################################################################
# Nat Gateway
# name rule : eip-[system]-[account]-[env]-[componet]-[region][az] 
#           : nat-[system]-[account]-[env]-[componet]-[region][az]
######################################################################################
module "nat_gateway" {
  source = "../modules/nat_gateway"

  eip_name  = format("eip-%s-%s-%s-nat-apn1d", var.system, var.account, var.env)
  nat_name  = format("nat-%s-%s-%s-test-apn1d", var.system, var.account, var.env)
  subnet_id = module.vpc.subnets["public-subnet01-d"].id
}