terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  backend "s3" {
    bucket         = "sk-terraform-tfstate-bkt"
    key            = "youtubeDownloader/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "sk-terraform-state-locking"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      envionment = "test"
      owner     = "terraform"
    }
  }
}