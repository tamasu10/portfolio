variable "parameter_group_name" {
  type = string
  default = ""
}

variable "parameter_group_family" {
  type = string
  default = ""
}

variable "parameter_group_parameters" {
  type = map(any)
  default = {}
}

variable "cluster_parameter_group_name" {
  type = string
  default = ""
}

variable "cluster_parameter_group_family" {
  type = string
  default = ""
}

variable "cluster_parameter_group_parameters" {
  type = map(any)
  default = {}
}