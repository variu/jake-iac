variable "aws_region" {
  default = "ap-northeast-1"
}

variable "aws_region_virginia" {
  default = "us-east-1"
}

variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "stage" {
  default = "develop"
}

variable "project_name" {
  default = "jake-park"
}

variable "cidr" {
  default = "10.10.0.0/16"
}

# aws ec2 describe-availability-zones --region ap-northeast-1
variable "azs" {
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}