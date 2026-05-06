resource "aws_api_gateway_rest_api" "this" {
  name = var.rest_api_name
}

# --- Ресурси ---
resource "aws_api_gateway_resource" "authors" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "authors"
}

resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "courses"
}

resource "aws_api_gateway_resource" "course_id" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}

# --- Методи та Інтеграції (Lambda Proxy) ---

# GET /authors
resource "aws_api_gateway_method" "get_authors" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "get_authors_int" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_authors.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_all_authors_lambda_invoke_arn
}

# GET /courses
resource "aws_api_gateway_method" "get_courses" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "get_courses_int" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.get_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_all_courses_lambda_invoke_arn
}

# POST /courses
resource "aws_api_gateway_method" "post_courses" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "post_courses_int" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.post_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.save_course_lambda_invoke_arn
}

# GET /courses/{id}
resource "aws_api_gateway_method" "get_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "get_course_int" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_course_lambda_invoke_arn
}

# PUT /courses/{id}
resource "aws_api_gateway_method" "put_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "PUT"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "put_course_int" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.put_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.update_course_lambda_invoke_arn
}

# DELETE /courses/{id}
resource "aws_api_gateway_method" "delete_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "delete_course_int" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.delete_course_lambda_invoke_arn
}

# --- Deployment ---
resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.get_authors_int,
    aws_api_gateway_integration.get_courses_int,
    aws_api_gateway_integration.post_courses_int,
    aws_api_gateway_integration.get_course_int,
    aws_api_gateway_integration.put_course_int,
    aws_api_gateway_integration.delete_course_int
  ]
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "prod"
}

output "base_url" {
  value = aws_api_gateway_deployment.this.invoke_url
}
