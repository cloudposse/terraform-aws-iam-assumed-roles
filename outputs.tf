#
# Group outputs
#
output "group_admin_id" {
  value       = join("", aws_iam_group.admin.*.id)
  description = "Admin group ID"
}

output "group_admin_arn" {
  value       = join("", aws_iam_group.admin.*.arn)
  description = "Admin group ARN"
}

output "group_admin_name" {
  value       = join("", aws_iam_group.admin.*.name)
  description = "Admin group name"
}

output "group_readonly_id" {
  value       = join("", aws_iam_group.readonly.*.id)
  description = "Readonly group ID"
}

output "group_readonly_arn" {
  value       = join("", aws_iam_group.readonly.*.arn)
  description = "Readonly group ARN"
}

output "group_readonly_name" {
  value       = join("", aws_iam_group.readonly.*.name)
  description = "Readonly group name"
}

#
# Role outputs
#
output "role_admin_arn" {
  value       = join("", aws_iam_role.admin.*.arn)
  description = "Admin role ARN"
}

output "role_admin_name" {
  value       = local.role_admin_name
  description = "Admin role name"
}

output "role_readonly_arn" {
  value       = join("", aws_iam_role.readonly.*.arn)
  description = "Readonly role ARN"
}

output "role_readonly_name" {
  value       = local.role_readonly_name
  description = "Readonly role name"
}

output "switchrole_admin_url" {
  description = "URL to the IAM console to switch to the admin role"
  value = local.enabled ? format(
    var.switchrole_url,
    data.aws_caller_identity.current.account_id,
    local.role_admin_name,
    local.role_admin_name,
  ) : ""
}

output "switchrole_readonly_url" {
  description = "URL to the IAM console to switch to the readonly role"
  value = local.enabled ? format(
    var.switchrole_url,
    data.aws_caller_identity.current.account_id,
    local.role_readonly_name,
    local.role_readonly_name,
  ) : ""
}

