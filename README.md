# Infrastructure.Terraform.Routes
Routes for LuGa that are not provisioned or assigned to existing service(s)

## Luga.co
### Environments
| Environment | Workspace                 | Domain Name                               |
|:------------|:--------------------------|:------------------------------------------|
| testing     | routes-luga-co-testing    | [testing.luga.co](http://testing.luga.co) |
| staging     | routes-luga-co-staging    | [staging.luga.co](http://staging.luga.co) |
| production  | routes-luga-co-production | [luga.co](http://luga.co)                 |

## Luga.online
### Environments
| Environment | Workspace                     | Domain Name                       |
|:------------|:------------------------------|:----------------------------------|
| production  | routes-luga-online-production | [luga.online](http://luga.online) |

## Apply Changes
1. `terraform plan`
2. `terraform apply` and `yes`