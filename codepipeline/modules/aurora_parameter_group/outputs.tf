output "parameter_group_id" {
  value = aws_db_parameter_group.aurora.id
}

output "cluster_parameter_group_id" {
  value = aws_rds_cluster_parameter_group.aurora.id
}