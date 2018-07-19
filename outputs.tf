# Group outputs
#
output "group_admin_id" {
  value       = "${aws_iam_group.admin.id}"
  description = "Admin group ID"
}

output "group_admin_arn" {
  value       = "${aws_iam_group.admin.arn}"
  description = "Admin group ARN"
}

output "group_admin_name" {
  value       = "${aws_iam_group.admin.name}"
  description = "Admin group name"
}

output "group_readonly_id" {
  value       = "${aws_iam_group.readonly.id}"
  description = "Readonly group ID"
}

output "group_readonly_arn" {
  value       = "${aws_iam_group.readonly.arn}"
  description = "Readonly group ARN"
}

output "group_readonly_name" {
  value       = "${aws_iam_group.readonly.name}"
  description = "Readonly group name"
}

# Role outputs
#
output "role_admin_arn" {
  value       = "${aws_iam_role.admin.arn}"
  description = "Admin role ARN"
}

output "role_admin_name" {
  value       = "${aws_iam_role.admin.name}"
  description = "Admin role name"
}

output "role_readonly_arn" {
  value       = "${aws_iam_role.readonly.arn}"
  description = "Readonly role ARN"
}

output "role_readonly_name" {
  value       = "${aws_iam_role.readonly.name}"
  description = "Readonly role name"
}
