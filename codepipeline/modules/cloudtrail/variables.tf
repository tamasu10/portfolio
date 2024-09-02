variable "name" {
  type = string
  default = ""
}

variable "s3_bucket_name" {
  type = string
  default = ""
}

variable "cloud_watch_logs_role_arn" {
  type = string
  default = ""
}

variable "cloud_watch_logs_group_arn" {
  type = string
  default = ""
}

variable "kms_key_id" {
  type = string
  default = ""
}

variable "enable_log_file_validation" {
  type = bool
  default = false
}

variable "is_multi_region_trail" {
  type = bool
  default = false
}

variable "is_organization_trail" {
  type = bool
  default = false
}

variable "event_selector" {
  type = list(any)
  default = []
}