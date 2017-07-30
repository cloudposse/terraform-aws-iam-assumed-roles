# tf_assumed_roles

Provides two IAM roles and two IAM groups allowing assume roles

### Module usage

```
module "assumed_roles" {
  source       = "github.com/cloudposse/tf_assumed_roles"
}
```

### Example usage

```
resource "aws_iam_user" "Alice" {
  name = "Alice"
}

resource "aws_iam_user" "Diana" {
  name = "Diana"
}

module "assumed_roles" {
  source       = "github.com/cloudposse/tf_assumed_roles"
}

# Alice will be in 'ops' group with 'AdministratorAcsess'
#
resource "aws_iam_group_membership" "ops" {
  name = "ops-group-membership"
  users = ["${aws_iam_user.Alice.name}"]
  group = "${module.assumed_roles.group_ops_name}"
}

# Diana will be in 'readonly' group with 'ReadOnlyAccess'
#
resource "aws_iam_group_membership" "ro" {
  name = "ro-group-membership"
  users = ["${aws_iam_user.Diana.name}"]
  group = "${module.assumed_roles.group_readonly_name}"
}

```

### Argument Reference

No arguments used

### Attributes Reference

- `group_ops_id` - the Administrator group's ID.
- `group_ops_arn` - the Amazon Resource Name (ARN) specifying the Administrator group.
- `group_ops_name` - the Administrator group's name.

- `group_readonly_id` - the ReadOnly group's ID.
- `group_readonly_arn` - the Amazon Resource Name (ARN) specifying the ReadOnly group.
- `group_readonly_name` - the ReadOnly group's name.

- `role_ops_arn` - the Amazon Resource Name (ARN) specifying the Administrator role.
- `role_ops_name` - the Administrator role's name.

- `role_readonly_arn` - the Amazon Resource Name (ARN) specifying the ReadOnly role.
- `role_readonly_name` - the ReadOnly role's name.
