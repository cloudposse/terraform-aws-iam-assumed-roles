
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin_name | Name for the admin group and role (e.g. `admin`) | string | `admin` | no |
| admin_user_names | Optional list of IAM user names to add to the admin group | list | `<list>` | no |
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | string | `-` | no |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| readonly_name | Name for the readonly group and role (e.g. `readonly`) | string | `readonly` | no |
| readonly_user_names | Optional list of IAM user names to add to the readonly group | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| group_admin_arn | Admin group ARN |
| group_admin_id | Group outputs |
| group_admin_name | Admin group name |
| group_readonly_arn | Readonly group ARN |
| group_readonly_id | Readonly group ID |
| group_readonly_name | Readonly group name |
| role_admin_arn | Role outputs |
| role_admin_name | Admin role name |
| role_readonly_arn | Readonly role ARN |
| role_readonly_name | Readonly role name |

