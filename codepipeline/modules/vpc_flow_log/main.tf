resource "aws_flow_log" "this" {
  iam_role_arn    = var.iam_role_arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = var.traffic_type
  vpc_id          = var.vpc_id
  tags = {
    Name = var.flow_log_name
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = var.cloudwatch_log_name
}
