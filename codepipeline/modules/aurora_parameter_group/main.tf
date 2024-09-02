resource "aws_db_parameter_group" "aurora" {
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.parameter_group_parameters

    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  tags   = {
    Name = var.parameter_group_name
  }
}

resource "aws_rds_cluster_parameter_group" "aurora" {
  family = var.cluster_parameter_group_family

  dynamic "parameter" {
    for_each = var.cluster_parameter_group_parameters

    content {
      name         = parameter.key
      value        = parameter.value["value"]
      apply_method = parameter.value["apply_method"]
    }
  }

  tags   = {
    Name = var.cluster_parameter_group_name
  }
}