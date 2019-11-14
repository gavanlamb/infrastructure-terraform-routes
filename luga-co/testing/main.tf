terraform {
  backend "s3" {
    bucket = "luga-terraform-remote-state"
    dynamodb_table = "luga-terraform-remote-state-lock"
    encrypt = true
    key = "state"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
  shared_credentials_file = "/Users/gavanlamb/.aws/Credentials"
  profile = "default"
}

data "terraform_remote_state" "luga-co" {
  backend = "s3"
  config = {
    bucket = "luga-terraform-remote-state"
    key = "env:/routes-luga-co-production/state"
    region = "ap-southeast-2"
  }
}

resource "aws_route53_zone" "testing-luga-co" {
  name = "testing.luga.co."
}

resource "aws_route53_record" "ns" {
  allow_overwrite = true
  zone_id = aws_route53_zone.testing-luga-co.zone_id
  name = "testing.luga.co."
  type = "NS"
  ttl = "300"

  records = [
    aws_route53_zone.testing-luga-co.name_servers[0],
    aws_route53_zone.testing-luga-co.name_servers[1],
    aws_route53_zone.testing-luga-co.name_servers[2],
    aws_route53_zone.testing-luga-co.name_servers[3]
  ]
}

resource "aws_route53_record" "luga-co-testing-ns" {
  allow_overwrite = true
  zone_id = data.terraform_remote_state.luga-co.outputs.zone-id
  name = "testing.luga.co."
  type = "NS"
  ttl = "300"

  records = [
    aws_route53_zone.testing-luga-co.name_servers[0],
    aws_route53_zone.testing-luga-co.name_servers[1],
    aws_route53_zone.testing-luga-co.name_servers[2],
    aws_route53_zone.testing-luga-co.name_servers[3]
  ]
}

resource "aws_route53_record" "aws-soa" {
  allow_overwrite = true
  zone_id = aws_route53_zone.testing-luga-co.zone_id
  name = "testing.luga.co."
  type = "SOA"
  ttl = "300"

  records = [
    "ns-1845.awsdns-38.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

output "zone-id" {
  value = aws_route53_zone.testing-luga-co.zone_id
}
output "domain" {
  value = substr(aws_route53_zone.testing-luga-co.name, 0, length(aws_route53_zone.testing-luga-co.name)-1)
}
