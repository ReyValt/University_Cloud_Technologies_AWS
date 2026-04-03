variable "function_name" {
  type = string
}

variable "dynamodb_actions" {
  type = list(string)
}

variable "dynamodb_table_arn" {
  type = string
}
