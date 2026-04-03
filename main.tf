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






# IAM roles
module "iam_get_all_authors" {
  source             = "./modules/iam"
  function_name      = "get-all-authors"
  dynamodb_actions   = ["dynamodb:Scan"]
  dynamodb_table_arn = module.dynamodb_authors.table_arn
}

module "iam_get_all_courses" {
  source             = "./modules/iam"
  function_name      = "get-all-courses"
  dynamodb_actions   = ["dynamodb:Scan"]
  dynamodb_table_arn = module.dynamodb_courses.table_arn
}

module "iam_get_course" {
  source             = "./modules/iam"
  function_name      = "get-course"
  dynamodb_actions   = ["dynamodb:GetItem"]
  dynamodb_table_arn = module.dynamodb_courses.table_arn
}

module "iam_save_course" {
  source             = "./modules/iam"
  function_name      = "save-course"
  dynamodb_actions   = ["dynamodb:PutItem"]
  dynamodb_table_arn = module.dynamodb_courses.table_arn
}

module "iam_update_course" {
  source             = "./modules/iam"
  function_name      = "update-course"
  dynamodb_actions   = ["dynamodb:PutItem"]
  dynamodb_table_arn = module.dynamodb_courses.table_arn
}

module "iam_delete_course" {
  source             = "./modules/iam"
  function_name      = "delete-course"
  dynamodb_actions   = ["dynamodb:DeleteItem"]
  dynamodb_table_arn = module.dynamodb_courses.table_arn
}

# Lambda functions
module "lambda_get_all_authors" {
  source        = "./modules/lambda"
  function_name = "get-all-authors"
  filename      = "${path.module}/builds/lambda/get-all-authors/function.zip"
  role_arn      = module.iam_get_all_authors.role_arn
  namespace     = var.namespace
  environment   = var.environment
  environment_variables = {
    AUTHORS_TABLE = module.dynamodb_authors.table_name
  }
}

module "lambda_get_all_courses" {
  source        = "./modules/lambda"
  function_name = "get-all-courses"
  filename      = "${path.module}/builds/lambda/get-all-courses/function.zip"
  role_arn      = module.iam_get_all_courses.role_arn
  namespace     = var.namespace
  environment   = var.environment
  environment_variables = {
    COURSES_TABLE = module.dynamodb_courses.table_name
  }
}

module "lambda_get_course" {
  source        = "./modules/lambda"
  function_name = "get-course"
  filename      = "${path.module}/builds/lambda/get-course/function.zip"
  role_arn      = module.iam_get_course.role_arn
  namespace     = var.namespace
  environment   = var.environment
  environment_variables = {
    COURSES_TABLE = module.dynamodb_courses.table_name
  }
}

module "lambda_save_course" {
  source        = "./modules/lambda"
  function_name = "save-course"
  filename      = "${path.module}/builds/lambda/save-course/function.zip"
  role_arn      = module.iam_save_course.role_arn
  namespace     = var.namespace
  environment   = var.environment
  environment_variables = {
    COURSES_TABLE = module.dynamodb_courses.table_name
  }
}

module "lambda_update_course" {
  source        = "./modules/lambda"
  function_name = "update-course"
  filename      = "${path.module}/builds/lambda/update-course/function.zip"
  role_arn      = module.iam_update_course.role_arn
  namespace     = var.namespace
  environment   = var.environment
  environment_variables = {
    COURSES_TABLE = module.dynamodb_courses.table_name
  }
}

module "lambda_delete_course" {
  source        = "./modules/lambda"
  function_name = "delete-course"
  filename      = "${path.module}/builds/lambda/delete-course/function.zip"
  role_arn      = module.iam_delete_course.role_arn
  namespace     = var.namespace
  environment   = var.environment
  environment_variables = {
    COURSES_TABLE = module.dynamodb_courses.table_name
  }
}