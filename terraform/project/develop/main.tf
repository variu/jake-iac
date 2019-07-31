terraform {
  backend "remote" {
    organization = "jake-park"
    workspaces {
      name = "develop"
    }
  }
}

provider "aws" {
  region = var.aws-region-tokyo
  shared_credentials_file = var.shared_credentials_file
}

provider "aws" {
  alias = "virginia"
  region = var.aws-region-virginia
  shared_credentials_file = var.shared_credentials_file
}
