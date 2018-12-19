module "admin_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.admin_name}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

module "readonly_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.readonly_name}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

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

data "aws_iam_policy_document" "manage_mfa" {
  statement {
    sid = "AllowUsersToCreateEnableResyncDeleteTheirOwnVirtualMFADevice"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:DeleteVirtualMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    sid = "AllowUsersToDeactivateTheirOwnVirtualMFADevice"

    actions = [
      "iam:DeactivateMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
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
      "iam:ListUsers",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "allow_change_password" {
  statement {
    actions   = [
      "iam:ChangePassword",
      "iam:GetLoginProfile"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}"]
  }

  statement {
    actions   = ["iam:GetAccountPasswordPolicy"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "allow_manage_access_keys" {
  statement {
    actions = [
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:UpdateAccessKey",
      "iam:GetUser",
      "iam:CreateAccessKey",
      "iam:ListAccessKeys",
    ]

    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}"]
  }

  statement {
    actions   = ["iam:ListUsers"]
    resources = ["*"]
  }
}

# Admin config

resource "aws_iam_policy" "manage_mfa_admin" {
  name        = "${module.admin_label.id}-permit-mfa"
  description = "Allow admin users to manage Virtual MFA Devices"
  policy      = "${data.aws_iam_policy_document.manage_mfa.json}"
}

resource "aws_iam_policy" "allow_change_password_admin" {
  name        = "${module.admin_label.id}-permit-change-password"
  description = "Allow admin users to change password"
  policy      = "${data.aws_iam_policy_document.allow_change_password.json}"
}

resource "aws_iam_policy" "allow_manage_access_keys_admin" {
  name        = "${module.admin_label.id}-permit-manage-keys"
  description = "Allow admin users to manage own access keys"
  policy      = "${data.aws_iam_policy_document.allow_manage_access_keys.json}"
}

data "aws_iam_policy_document" "assume_role_admin" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.admin.arn}"]
  }
}

resource "aws_iam_policy" "assume_role_admin" {
  name        = "${module.admin_label.id}-permit-assume-role"
  description = "Allow assuming admin role"
  policy      = "${data.aws_iam_policy_document.assume_role_admin.json}"
}

resource "aws_iam_group" "admin" {
  name = "${module.admin_label.id}"
}

resource "aws_iam_role" "admin" {
  name               = "${module.admin_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.role_trust.json}"
}

resource "aws_iam_group_policy_attachment" "assume_role_admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "${aws_iam_policy.assume_role_admin.arn}"
}

resource "aws_iam_group_policy_attachment" "manage_mfa_admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "${aws_iam_policy.manage_mfa_admin.arn}"
}

resource "aws_iam_group_policy_attachment" "allow_chage_password_admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "${aws_iam_policy.allow_change_password_admin.arn}"
}

resource "aws_iam_group_policy_attachment" "manage_access_key_admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "${aws_iam_policy.allow_manage_access_keys_admin.arn}"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_membership" "admin" {
  count = "${length(var.admin_user_names) > 0 ? 1 : 0}"
  name  = "${module.admin_label.id}"
  group = "${aws_iam_group.admin.id}"
  users = ["${var.admin_user_names}"]
}

# Readonly config

resource "aws_iam_policy" "manage_mfa_readonly" {
  name        = "${module.readonly_label.id}-permit-mfa"
  description = "Allow readonly users to manage Virtual MFA Devices"
  policy      = "${data.aws_iam_policy_document.manage_mfa.json}"
}

resource "aws_iam_policy" "allow_change_password_readonly" {
  name        = "${module.readonly_label.id}-permit-change-password"
  description = "Allow readonly users to change password"
  policy      = "${data.aws_iam_policy_document.allow_change_password.json}"
}

resource "aws_iam_policy" "allow_manage_access_keys_readonly" {
  name        = "${module.readonly_label.id}-permit-manage-keys"
  description = "Allow readonly users to manage own access keys"
  policy      = "${data.aws_iam_policy_document.allow_manage_access_keys.json}"
}

data "aws_iam_policy_document" "assume_role_readonly" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.readonly.arn}"]
  }
}

resource "aws_iam_policy" "assume_role_readonly" {
  name        = "${module.readonly_label.id}-permit-assume-role"
  description = "Allow assuming readonly role"
  policy      = "${data.aws_iam_policy_document.assume_role_readonly.json}"
}

resource "aws_iam_group" "readonly" {
  name = "${module.readonly_label.id}"
}

resource "aws_iam_role" "readonly" {
  name               = "${module.readonly_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.role_trust.json}"
}

resource "aws_iam_group_policy_attachment" "assume_role_readonly" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.assume_role_readonly.arn}"
}

resource "aws_iam_group_policy_attachment" "manage_mfa_readonly" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.manage_mfa_readonly.arn}"
}

resource "aws_iam_group_policy_attachment" "allow_change_password_readonly" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.allow_change_password_readonly.arn}"
}

resource "aws_iam_group_policy_attachment" "manage_access_key_readonly" {
  group      = "${aws_iam_group.readonly.name}"
  policy_arn = "${aws_iam_policy.allow_manage_access_keys_readonly.arn}"
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = "${aws_iam_role.readonly.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_membership" "readonly" {
  count = "${length(var.readonly_user_names) > 0 ? 1 : 0}"
  name  = "${module.readonly_label.id}"
  group = "${aws_iam_group.readonly.id}"
  users = ["${var.readonly_user_names}"]
}
