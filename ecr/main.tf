provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Application = "${local.appname}"
    }
  }
}

terraform {
  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.0"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }
}
