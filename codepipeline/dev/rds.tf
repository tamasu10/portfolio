######################################################################################
# rds
# name rule : [system]-[account]-[env]-[component]
######################################################################################
module "rds-mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.5.0"

  identifier        = format("rds-%s-%s-%s-test01", var.system, var.account, var.env)
  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.large"
  allocated_storage = 5

  name     = format("rds-%s-%s-%s-test01", var.system, var.account, var.env)
  username = "user01"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "3306"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [module.sg_rds.security_group_id]

  maintenance_window = "sun:05:00-sun:06:00"
  backup_window      = "03:00-05:00"

  monitoring_interval    = 60
  monitoring_role_name   = format("role-%s-%s-%s-rds-monitoring01", var.system, var.account, var.env)
  create_monitoring_role = true

  tags = {
     Name     = format("rds-%s-%s-%s-test01", var.system, var.account, var.env)
  }

  subnet_ids = [module.vpc.subnets["private-subnet05-a"].id,
  module.vpc.subnets["private-subnet06-c"].id]
  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  deletion_protection = false

  parameters = [
  ]

  options = [
  ]
}