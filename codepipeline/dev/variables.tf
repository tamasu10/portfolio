######################################################################################
# Common
######################################################################################
variable "env" { default = "dev" }
variable "system" { default = "aap-template" }
variable "account" { default = "account" }
variable "region" { default = "ap-northeast-1" }
variable "profile" { default = "arise-pod-dev" }


######################################################################################
# account ID
######################################################################################
data "aws_caller_identity" "current" {}