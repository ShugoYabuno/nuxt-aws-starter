variable "aws_account_id" {}

variable "project_name" {}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "ap-northeast-1"
}

variable "internet_access" {
  default = "0.0.0.0/0"
}
