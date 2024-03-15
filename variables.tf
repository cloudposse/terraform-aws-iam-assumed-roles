variable "admin_name" {
  type        = string
  default     = "admin"
  description = "Name for the admin group and role (e.g. `admin`)"
}

variable "readonly_name" {
  type        = string
  default     = "readonly"
  description = "Name for the readonly group and role (e.g. `readonly`)"
}

variable "admin_user_names" {
  type        = list(string)
  default     = []
  description = "Optional list of IAM user names to add to the admin group"
}

variable "readonly_user_names" {
  type        = list(string)
  default     = []
  description = "Optional list of IAM user names to add to the readonly group"
}

variable "switchrole_url" {
  type        = string
  description = "URL to the IAM console to switch to a role"
  default     = "https://signin.aws.amazon.com/switchrole?account=%s&roleName=%s&displayName=%s"
}
