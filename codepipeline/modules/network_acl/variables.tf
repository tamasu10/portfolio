variable "name" {
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "subnet_ids" {
  type = list(string)
  default = []
}

variable "ingress" {
  type = list(any)
  default = []
}

variable "egress" {
  type = list(any)
  default = []
}