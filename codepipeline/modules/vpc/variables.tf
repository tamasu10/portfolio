######################################################################################
# VPC
######################################################################################
variable "vpc_name" {
  type = string
  default = ""
}

variable "vpc_cidr" {
  type = string
  default = ""
}

variable "tenancy" {
  type = string
  default = "default"
}

variable "enable_dns_hostnames" {
  type = bool
  default = false
}

variable "enable_dns_support" {
  type = bool
  default = false
}

######################################################################################
# Subnet
######################################################################################
variable "subnets" {
  type = map(any)
  default = {}
}
