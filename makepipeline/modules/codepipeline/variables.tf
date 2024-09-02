variable "codepipeline_name" {
  type = string
  default = ""
}

variable "role_arn" {
  type = string
  default = ""
}

variable "artifact_store_location" {
  type = string
  default = ""
}

variable "artifact_store_type" {
  type = string
  default = ""
}

variable "stage" {
  type = any
  default = []
}