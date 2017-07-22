variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "role"
}

variable "iam_user_arn" {
  description = "IAM user arn or list of IAM user arns separated by comma"
}
