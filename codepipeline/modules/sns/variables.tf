variable "name" {
  type = string
  default = ""
}

variable "fifo_topic" {
  type = bool
  default = false
}

variable "display_name" {
  type = string
  default = ""
}

variable "kms_master_key_id" {
  type = string
  default = ""
}

variable "policy" {
  type = string
  default = ""
}

variable "delivery_policy" {
  type = string
  default = ""
}

variable "http_success_feedback_sample_rate" {
  type = string
  default = ""
}

variable "protocol" {
  type = string
  default = ""
}

variable "endpoint" {
  type = string
  default = ""
}