data "aws_iam_policy_document" "assume-role-policy" {
  statement {

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${split(",",var.iam_user_arn)}"]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

  }
}

resource "aws_iam_role" "ops" {
  name = "ops"
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"
}
resource "aws_iam_role_policy_attachment" "ops" {
    role       = "${aws_iam_role.ops.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "readonly" {
  name = "readonly"
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"
}
resource "aws_iam_role_policy_attachment" "readonly" {
    role       = "${aws_iam_role.readonly.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
