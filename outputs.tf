# Group outputs
#
output "group_admin_id" {
  value = "${aws_iam_group.admin.id}"
}

output "group_admin_arn" {
  value = "${aws_iam_group.admin.arn}"
}

output "group_admin_name" {
  value = "${aws_iam_group.admin.name}"
}

output "group_readonly_id" {
  value = "${aws_iam_group.readonly.id}"
}

output "group_readonly_arn" {
  value = "${aws_iam_group.readonly.arn}"
}

output "group_readonly_name" {
  value = "${aws_iam_group.readonly.name}"
}

# Role outputs
#
output "role_admin_arn" {
  value = "${aws_iam_role.admin.arn}"
}

output "role_admin_name" {
  value = "${aws_iam_role.admin.name}"
}

output "role_readonly_arn" {
  value = "${aws_iam_role.readonly.arn}"
}

output "role_readonly_name" {
  value = "${aws_iam_role.readonly.name}"
}
