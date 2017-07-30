data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "role-trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

  }
}

data "aws_iam_policy_document" "AssumeRoleOps" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.ops.arn}"]
  }
}
resource "aws_iam_policy" "AssumeRoleOps" {
  name        = "AssumeRoleOps"
  policy      = "${data.aws_iam_policy_document.AssumeRoleOps.json}"
}

data "aws_iam_policy_document" "AssumeRoleReadOnly" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.readonly.arn}"]
  }
}
resource "aws_iam_policy" "AssumeRoleReadOnly" {
  name        = "AssumeRoleReadOnly"
  policy      = "${data.aws_iam_policy_document.AssumeRoleReadOnly.json}"
}

data "aws_iam_policy_document" "ManageMFA" {
  statement {
    sid = "AllowUsersToCreateEnableResyncDeleteTheirOwnVirtualMFADevice"
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:DeleteVirtualMFADevice"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}"
    ]
  }
  statement {
    sid = "AllowUsersToDeactivateTheirOwnVirtualMFADevice"
    actions = [
      "iam:DeactivateMFADevice"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
  statement {
    sid = "AllowUsersToListMFADevicesandUsersForConsole"
    actions = [
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ListUsers"
    ]
    resources = [
      "*"
    ]
  }
}
resource "aws_iam_policy" "ManageMFA" {
  name        = "AllowUsersToDeactivateTheirOwnVirtualMFADevice"
  policy      = "${data.aws_iam_policy_document.ManageMFA.json}"
}

resource "aws_iam_group" "ops" {
  name = "ops"
}
resource "aws_iam_group_policy_attachment" "AssumeRoleOps" {
  group      = "${aws_iam_group.ops.name}"
  policy_arn = "${aws_iam_policy.AssumeRoleOps.arn}"
}
resource "aws_iam_group_policy_attachment" "ManageMFA-ops" {
  group      = "${aws_iam_group.ops.name}"
  policy_arn = "${aws_iam_policy.ManageMFA.arn}"
}

resource "aws_iam_group" "readonly" {
  name = "readonly"
}
resource "aws_iam_group_policy_attachment" "AssumeRoleReadOnly" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.AssumeRoleReadOnly.arn}"
}
resource "aws_iam_group_policy_attachment" "ManageMFA-ro" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.ManageMFA.arn}"
}

resource "aws_iam_role" "ops" {
  name = "ops"
  assume_role_policy = "${data.aws_iam_policy_document.role-trust.json}"
}
resource "aws_iam_role_policy_attachment" "ops" {
    role       = "${aws_iam_role.ops.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "readonly" {
  name = "readonly"
  assume_role_policy = "${data.aws_iam_policy_document.role-trust.json}"
}
resource "aws_iam_role_policy_attachment" "readonly" {
    role       = "${aws_iam_role.readonly.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
