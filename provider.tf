terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  backend "remote" {
    organization = "sk-tf-cloud"
    workspaces {
      name = "youtube_downloader"
    }
  }
}

provider "aws" {
  region = var.v_aws_region
  default_tags {
    tags = {
      envionment = "test"
      owner     = "terraform"
    }
  }
}