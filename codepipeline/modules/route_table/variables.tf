######################################################################################
# Routetable
######################################################################################
variable "vpc_id" {
  type = string
  default = ""
}

variable "route_table_name" {
  type = string
  default = ""
}

variable "route" {
  type = list(any)
  default = []
}

variable "subnet_ids" {
  type = list(string)
  default = []
}
