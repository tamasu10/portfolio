resource "aws_config_delivery_channel" "this" {
  name           = var.delivery_channel_name
  s3_bucket_name = var.s3_bucket
  depends_on     = [aws_config_configuration_recorder.this]
  sns_topic_arn  = var.sns_topic_arn
}

resource "aws_config_configuration_recorder" "this" {
  name            = var.recorder_name
  role_arn        = var.role_arn
  recording_group {
    all_supported                 = var.recording_group.all_supported
    include_global_resource_types = var.recording_group.include_global_resource_types
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = var.is_enabled
  depends_on = [aws_config_delivery_channel.this]
}