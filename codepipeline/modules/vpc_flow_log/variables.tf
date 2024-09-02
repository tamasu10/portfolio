variable "vpc_id" {
  type = string
  default = ""
}

variable "flow_log_name" {
  type = string
  default = ""
}

variable "cloudwatch_log_name" {
  type = string
  default = ""
}

variable "traffic_type" {
  type = string
  default = ""
}

variable "iam_role_arn" {
  type = string
  default = ""
}

# variable "iam_role_name" {
#   type = string
#   default = ""
# }

# variable "assume_role_policy" {
#   type = string
#   default = ""
# }

# variable "iam_role_policy_name" {
#   type = string
#   default = ""
# }

# variable "policy" {
#   type = string
#   default = ""
# }