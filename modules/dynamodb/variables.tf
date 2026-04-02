variable "context" {
  type    = any
  default = {}
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}
