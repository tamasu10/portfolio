######################################################################################
# Routetable
# name rule : rtb-[system]-[account]-[env]-[componet][no2]-[pub|pri]-[region][az]
######################################################################################
module "route_table_ec2" {
  source = "../modules/route_table"

  vpc_id           = module.vpc.vpc_id
  route_table_name = format("rtb-%s-%s-%s-test01-pri-apn1a", var.system, var.account, var.env)
  route = [
    {
      cidr_block         = "0.0.0.0/0"
      instance_id        = ""
      transit_gateway_id = ""
      gateway_id         = ""
      nat_gateway_id     = module.nat_gateway.id
    }
  ]
  subnet_ids = [
    module.vpc.subnets["private-subnet02-a"].id
  ]
}

module "route_table_nat" {
  source = "../modules/route_table"

  vpc_id           = module.vpc.vpc_id
  route_table_name = format("rtb-aap-%s-%s-%s-nat01-pub-apn1d", var.system, var.account, var.env)
  route = [
    {
      cidr_block         = "0.0.0.0/0"
      instance_id        = ""
      transit_gateway_id = ""
      gateway_id         = module.internet_gateway.igw_id
      nat_gateway_id     = ""
    }
  ]
  subnet_ids = [
    module.vpc.subnets["public-subnet01-d"].id
  ]
}

module "route_table_aurora" {
  source = "../modules/route_table"

  vpc_id           = module.vpc.vpc_id
  route_table_name = format("rtb-aap-%s-%s-%s-aurora-test01-pri-apn1ac", var.system, var.account, var.env)
  route = [
    {
      cidr_block         = "10.100.2.0/24"
      instance_id        = ""
      transit_gateway_id = ""
      gateway_id         = ""
      nat_gateway_id     = ""
    }
  ]
  subnet_ids = [
    module.vpc.subnets["private-subnet03-a"].id,
    module.vpc.subnets["private-subnet04-c"].id
  ]
}

module "route_table_rds" {
  source = "../modules/route_table"

  vpc_id           = module.vpc.vpc_id
  route_table_name = format("rtb-aap-%s-%s-%s-rds-test01-pri-apn1ac", var.system, var.account, var.env)
  route = [
    {
      cidr_block         = "10.100.2.0/24"
      instance_id        = ""
      transit_gateway_id = ""
      gateway_id         = ""
      nat_gateway_id     = ""
    }
  ]
  subnet_ids = [
    module.vpc.subnets["private-subnet05-a"].id,
    module.vpc.subnets["private-subnet06-c"].id
  ]
}