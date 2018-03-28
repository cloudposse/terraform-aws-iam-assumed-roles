# terraform-aws-iam-assumed-roles [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-iam-assumed-roles.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-iam-assumed-roles)

Terraform module to provision two IAM roles and two IAM groups for assuming the roles provided MFA is present.

- Role and group with Administrator (full) access to AWS resources
- Role and group with ReadOnly access to AWS resources

To give a user administrator's access, add the user to the Administrator group.

To give a user readonly access, add the user to the ReadOnly group.


## Usage

```hcl
module "assumed_roles" {
  source        = "git::https://github.com/cloudposse/terraform-aws-iam-assumed-roles.git?ref=master"
  namespace     = "cp"
  stage         = "prod"
  admin_name    = "admin"
  readonly_name = "readonly"
}
```


## Variables

|  Name              |  Default           |  Description                                                                    | Required |
|:-------------------|:-------------------|:--------------------------------------------------------------------------------|:--------:|
| `namespace`        | ``                 | Namespace (_e.g._ `cp` or `cloudposse`)                                         | Yes      |
| `stage`            | ``                 | Stage (_e.g._ `prod`, `dev`, `staging`)                                         | Yes      |
| `admin_name`       | `admin`            | Name for the admin group and role                                               | Yes      |
| `readonly_name`    | `readonly`         | Name for the readonly group and role                                            | Yes      |
| `attributes`       | `[]`               | Additional attributes (_e.g._ `policy` or `role`)                               | No       |
| `tags`             | `{}`               | Additional tags (_e.g._ `map("BusinessUnit","XYZ")`                             | No       |
| `delimiter`        | `-`                | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`     | No       |


## Outputs

| Name                     | Description                  |
|:-------------------------|:-----------------------------|
| `group_admin_id`         | Administrator group ID       |
| `group_admin_arn`        | Administrator group ARN      |
| `group_admin_name`       | Administrator group name     |
| `group_readonly_id`      | ReadOnly group ID            |
| `group_readonly_arn`     | ReadOnly group ARN           |
| `group_readonly_name`    | ReadOnly group name          |
| `role_admin_arn`         | Administrator role ARN       |
| `role_admin_name`        | Administrator role name      |
| `role_readonly_arn`      | ReadOnly role ARN            |
| `role_readonly_name`     | ReadOnly role name           |


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-iam-assumed-roles/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Gitter](https://gitter.im/cloudposse/).


## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-iam-assumed-roles/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing `terraform-aws-iam-assumed-roles`, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!


## License

[APACHE 2.0](LICENSE) © 2018 [Cloud Posse, LLC](https://cloudposse.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


## About

`terraform-aws-iam-assumed-roles` is maintained and funded by [Cloud Posse, LLC][website].

![Cloud Posse](https://cloudposse.com/logo-300x69.png)


Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)!

See [our other projects][community]
or [hire us][hire] to help build your next cloud platform.

  [website]: https://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: https://cloudposse.com/contact/


### Contributors

| [![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] | [![Andriy Knysh][andriy_img]][andriy_web]<br/>[Andriy Knysh][andriy_web] |
|-------------------------------------------------------|------------------------------------------------------------------|

  [erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
  [erik_web]: https://github.com/osterman/
  [andriy_img]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
  [andriy_web]: https://github.com/aknysh/
