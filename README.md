# terraform-aws-iam-assumed-roles

Provides two IAM roles and two IAM groups for assuming these roles provided MFA is present.

- role and group named as **ops** has Administratror (full) access to AWS resources
- role and group named as **readonly** has ReadOnly access to AWS resources

To give some user Administrator's access just add user to group **ops**

### Module usage

```hcl
module "assumed_roles" {
  source       = "git::https://github.com/cloudposse/tf_assumed_roles.git?ref=master"
}
```

### Example usage

```hcl
resource "aws_iam_user" "Alice" {
  name = "Alice"
}

resource "aws_iam_user" "Diana" {
  name = "Diana"
}

module "assumed_roles" {
  source              = "github.com/cloudposse/tf_assumed_roles"
  admin_group_name    = "Admins"
  readonly_group_name = "Watchers"
}

# Alice will be in 'ops' group with 'AdministratorAcsess'
#
resource "aws_iam_group_membership" "admin" {
  name = "ops-group-membership"
  users = ["${aws_iam_user.Alice.name}"]
  group = "${module.assumed_roles.group_admin_name}"
}

# Diana will be in 'readonly' group with 'ReadOnlyAccess'
#
resource "aws_iam_group_membership" "readonly" {
  name = "ro-group-membership"
  users = ["${aws_iam_user.Diana.name}"]
  group = "${module.assumed_roles.group_readonly_name}"
}

```

### Argument Reference

- `admin_role_name` - (Optional, default "ops") Name for IAM role with Administrator access
- `admin_group_name` - (Optional, default "ops") Name for group assuming ops role
- `readonly_role_name` - (Optional, default "readonly") Name for IAM role with ReadOnly access
- `readonly_group_name` - (Optional, default "readonly") Name for group assuming readonly IAM role

### Attributes Reference

- `group_admin_id` - the Administrator group's ID.
- `group_admin_arn` - the Amazon Resource Name (ARN) specifying the Administrator group.
- `group_admin_name` - the Administrator group's name.

- `group_readonly_id` - the ReadOnly group's ID.
- `group_readonly_arn` - the Amazon Resource Name (ARN) specifying the ReadOnly group.
- `group_readonly_name` - the ReadOnly group's name.

- `role_admin_arn` - the Amazon Resource Name (ARN) specifying the Administrator role.
- `role_admin_name` - the Administrator role's name.

- `role_readonly_arn` - the Amazon Resource Name (ARN) specifying the ReadOnly role.
- `role_readonly_name` - the ReadOnly role's name.
