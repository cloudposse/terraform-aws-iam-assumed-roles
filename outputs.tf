output "ops_arn" {
  value = "${aws_iam_role.ops.arn}"
}

output "readonly_arn" {
  value = "${aws_iam_role.readonly.arn}"
}
