variable "codebuild_name" {
  type = string
  default = ""
}

variable "service_role" {
  type = string
  default = ""
}

variable "artifacts_type" {
  type = string
  default = ""
}

variable "environment" {
  type = list(any)
  default = []
}

variable "cloudwatch_logs_group_name" {
  type = string
  default = ""
}

variable "cloudwatch_logs_stream_name" {
  type = string
  default = ""
}

variable "source_type" {
  type = string
  default = ""
}

variable "source_location" {
  type = string
  default = ""
}

variable "source_version" {
  type = string
  default = ""
}