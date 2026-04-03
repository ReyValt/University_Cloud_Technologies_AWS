variable "namespace" {
  type    = string
  default = "uni"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "function_name" {
  type = string
}

variable "filename" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}
