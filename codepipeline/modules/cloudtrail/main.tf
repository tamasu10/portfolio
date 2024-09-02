resource "aws_cloudtrail" "this" {
  name                       = var.name
  s3_bucket_name             = var.s3_bucket_name
  cloud_watch_logs_role_arn  = "${var.cloud_watch_logs_role_arn}"
  cloud_watch_logs_group_arn = "${var.cloud_watch_logs_group_arn}:*"
  kms_key_id                 = var.kms_key_id
  enable_log_file_validation = var.enable_log_file_validation
  is_multi_region_trail      = var.is_multi_region_trail
  is_organization_trail      = var.is_organization_trail

  dynamic "event_selector" {
    for_each = var.event_selector

    content {
      read_write_type = event_selector.value["read_write_type"]
      include_management_events = event_selector.value["include_management_events"]

      dynamic "data_resource" {
        for_each = event_selector.value["data_resource"]
        content {
          type = data_resource.value["type"]
          values = data_resource.value["values"]
        }
      }
    }
  }
}
