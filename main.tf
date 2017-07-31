data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "role_trust" {
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

data "aws_iam_policy_document" "assume_role_ops" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.ops.arn}"]
  }
}
resource "aws_iam_policy" "assume_role_ops" {
  name        = "AssumeRoleOps"
  policy      = "${data.aws_iam_policy_document.assume_role_ops.json}"
}

data "aws_iam_policy_document" "assume_role_readonly" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.readonly.arn}"]
  }
}
resource "aws_iam_policy" "assume_role_readonly" {
  name        = "AssumeRoleReadOnly"
  policy      = "${data.aws_iam_policy_document.assume_role_readonly.json}"
}

data "aws_iam_policy_document" "manage_mfa" {
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
resource "aws_iam_policy" "manage_mfa" {
  name        = "AllowUsersToDeactivateTheirOwnVirtualMFADevice"
  policy      = "${data.aws_iam_policy_document.manage_mfa.json}"
}

data "aws_iam_policy_document" "allow_change_password" {
  statement {
    actions = ["iam:ChangePassword"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}"]
  }
  statement {
    actions = ["iam:GetAccountPasswordPolicy"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "allow_change_password" {
  name        = "AllowChangePassword"
  policy      = "${data.aws_iam_policy_document.allow_change_password.json}"
}


resource "aws_iam_group" "ops" {
  name = "${var.ops_group_name}"
}
resource "aws_iam_group_policy_attachment" "assume_role_ops" {
  group      = "${aws_iam_group.ops.name}"
  policy_arn = "${aws_iam_policy.assume_role_ops.arn}"
}
resource "aws_iam_group_policy_attachment" "manage_mfa_ops" {
  group      = "${aws_iam_group.ops.name}"
  policy_arn = "${aws_iam_policy.manage_mfa.arn}"
}
resource "aws_iam_group_policy_attachment" "allow_chage_password_ops" {
  group      = "${aws_iam_group.ops.name}"
  policy_arn = "${aws_iam_policy.allow_change_password.arn}"
}

resource "aws_iam_group" "readonly" {
  name = "${var.readonly_group_name}"
}
resource "aws_iam_group_policy_attachment" "assume_role_readonly" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.assume_role_readonly.arn}"
}
resource "aws_iam_group_policy_attachment" "manage_mfa_readonly" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.manage_mfa.arn}"
}
resource "aws_iam_group_policy_attachment" "allow_change_password_readonly" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.allow_change_password.arn}"
}

resource "aws_iam_role" "ops" {
  name = "${var.ops_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.role_trust.json}"
}
resource "aws_iam_role_policy_attachment" "ops" {
    role       = "${aws_iam_role.ops.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "readonly" {
  name = "${var.readonly_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.role_trust.json}"
}
resource "aws_iam_role_policy_attachment" "readonly" {
    role       = "${aws_iam_role.readonly.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
