variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "enabled" {
  type        = "string"
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "admin_name" {
  type        = "string"
  default     = "admin"
  description = "Name for the admin group and role (e.g. `admin`)"
}

variable "readonly_name" {
  type        = "string"
  default     = "readonly"
  description = "Name for the readonly group and role (e.g. `readonly`)"
}

variable "admin_user_names" {
  type        = "list"
  default     = []
  description = "Optional list of IAM user names to add to the admin group"
}

variable "readonly_user_names" {
  type        = "list"
  default     = []
  description = "Optional list of IAM user names to add to the readonly group"
}
