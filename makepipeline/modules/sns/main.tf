resource "aws_sns_topic" "this" {
  name              = var.name
  fifo_topic        = var.fifo_topic
  display_name      = var.display_name
  kms_master_key_id = var.kms_master_key_id 
#   policy            = var.policy
#   delivery_policy   = var.delivery_policy
  http_success_feedback_sample_rate = var.http_success_feedback_sample_rate

  tags = {
    Name = var.name
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}