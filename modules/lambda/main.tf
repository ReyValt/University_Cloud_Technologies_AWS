module "labels" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = var.namespace
  environment = var.environment
  name        = var.function_name
}

resource "aws_lambda_function" "this" {
  filename      = var.filename
  function_name = module.labels.id
  role          = var.role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  environment {
    variables = var.environment_variables
  }

  tags = module.labels.tags
}
