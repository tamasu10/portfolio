######################################################################################
# Aurora
# name rule : [system]-[account]-[env]-[component][no2]
######################################################################################

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "5.2.0"

  name                       = format("aurora-%s-%s-%s-test01", var.system, var.account, var.env)
  engine                     = "aurora-mysql"
  engine_version             = "5.7.mysql_aurora.2.09.2"
  auto_minor_version_upgrade = false
  instance_type              = "db.r5.large"
  create_random_password     = false
  password                   = "Example0000"
  vpc_id                     = module.vpc.vpc_id
  # db_subnet_group_name   = module.db_subnet_group.name
  # db_subnet_group_name = format("sbg-%s-%s-%s-aurora", var.system, var.account, var.env)
  subnets = [
    module.vpc.subnets["private-subnet03-a"].id,
    module.vpc.subnets["private-subnet04-c"].id
  ]
  publicly_accessible    = false
  create_security_group  = false
  vpc_security_group_ids = [module.sg_aurora.security_group_id]

  cluster_tags = {
    Name = format("cluster-aurora-%s-%s-%s-test01", var.system, var.account, var.env)
  }

  tags = {
    Name = format("aurora-%s-%s-%s-test01", var.system, var.account, var.env)
  }

  # database_name                       = format(var.aurora.database_name, var.project, var.env)
  port                                = 3306
  db_parameter_group_name             = module.aurora_parameter_group.parameter_group_id
  db_cluster_parameter_group_name     = module.aurora_parameter_group.cluster_parameter_group_id
  iam_database_authentication_enabled = false
  backup_retention_period             = 7
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  replica_count                       = 2
  instance_type_replica               = "db.r5.large"
  # backtrack_window                    = 86400
  create_monitoring_role       = true
  monitoring_interval          = 60
  preferred_maintenance_window = "sun:05:00-sun:06:00"
  copy_tags_to_snapshot        = true
  performance_insights_enabled = false

}

module "aurora_parameter_group" {
  source = "../modules/aurora_parameter_group"

  parameter_group_name   = format("pg-aurora-%s-%s-%s-test01", var.system, var.account, var.env)
  parameter_group_family = "aurora-mysql5.7"
  parameter_group_parameters = {
    "slow_query_log"                  = 1
    "log_bin_trust_function_creators" = 1
  }
  cluster_parameter_group_name   = format("pg-cluster-aurora-%s-%s-%s-test01", var.system, var.account, var.env)
  cluster_parameter_group_family = "aurora-mysql5.7"
  cluster_parameter_group_parameters = {
    "binlog_format" = {
      value        = "row"
      apply_method = "pending-reboot"
    }
    "character_set_client" = {
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    }
    "character_set_connection" = {
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    }
    "character_set_database" = {
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    }
    "character_set_results" = {
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    }
    "character_set_server" = {
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    }
    "collation_connection" = {
      value        = "utf8mb4_bin"
      apply_method = "pending-reboot"
    }
    "collation_server" = {
      value        = "utf8mb4_bin"
      apply_method = "pending-reboot"
    }
    "server_audit_events" = {
      value        = "connect,query,query_dcl,query_ddl,query_dml,table"
      apply_method = "pending-reboot"
    }
    "server_audit_logging" = {
      value        = 1
      apply_method = "pending-reboot"
    }
    "time_zone" = {
      value        = "asia/tokyo"
      apply_method = "pending-reboot"
    }
    "long_query_time" = {
      value        = "1800"
      apply_method = "pending-reboot"
    }
  }
}