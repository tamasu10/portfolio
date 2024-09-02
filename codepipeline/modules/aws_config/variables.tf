variable "delivery_channel_name" {
  type = string
  default = ""
}

variable "s3_bucket" {
  type = string
  default = ""
}

variable "recorder_name" {
  type = string
  default = ""
}

variable "role_arn" {
  type = string
  default = ""
}

variable "sns_topic_arn" {
  type = string
  default = ""
}

variable "is_enabled" {
  type = bool
  default = false
}

variable "recording_group" {
  type = map(any)
  default = {}
}