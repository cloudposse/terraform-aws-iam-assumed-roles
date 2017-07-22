# tf_assumed_roles

Provides two IAM roles.

### Module usage

```
module "assumed_roles" {
  source       = "github.com/cloudposse/tf_assumed_roles"
  iam_user_arn = "arn:aws:iam::123456789000:user/geodesic"
}
```

### Example usage

```
resource "aws_iam_user" "deploy" {
  name = "deploy"
}

resource "aws_iam_user" "op" {
  name = "operator"
}

module "assumed_roles" {
  source       = "github.com/cloudposse/tf_assumed_roles"
  iam_user_arn = "${aws_iam_user.deploy.arn},${aws_iam_user.op.arn}"
  namespace    = "test"
  stage        = "dev"
  name         = "role"
}
```

### Argument Reference

- `iam_user_arn` - (Required) The single or comma separated list of the ARN'a assigned by AWS for user.
- `namespace` - (Optional, default "global") Namespace
- `stage`  - (Optional, default "default") Stage name
- `name` - (Optional, default "role") Role name prefix

### Attributes Reference

- `ops_arn` - the Amazon Resource Name (ARN) specifying the Administrator role.
- `readonly_arn` - the Amazon Resource Name (ARN) specifying the ReadOnly role.
