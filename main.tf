terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "235553267029-terraform-tfstate"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-tfstate-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "dynamodb_courses" {
  source     = "./modules/dynamodb"
  table_name = "courses"
  context    = module.this.context
}

module "dynamodb_authors" {
  source     = "./modules/dynamodb"
  table_name = "authors"
  context    = module.this.context
}
