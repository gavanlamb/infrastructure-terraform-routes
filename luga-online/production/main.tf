provider "aws" {
  region = "ap-southeast-2"
  shared_credentials_file = "/Users/gavanlamb/.aws/Credentials"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "luga-terraform-remote-state"
    dynamodb_table = "luga-terraform-remote-state-lock"
    encrypt = true
    key = "state"
    region = "ap-southeast-2"
  }
}

resource "aws_route53_zone" "luga-online" {
  name = "luga.online."
}

resource "aws_route53_record" "ns" {
  allow_overwrite = true
  zone_id = aws_route53_zone.luga-online.zone_id
  name = "luga.online"
  type = "NS"
  ttl = "300"

  records = [
    aws_route53_zone.luga-online.name_servers[0],
    aws_route53_zone.luga-online.name_servers[1],
    aws_route53_zone.luga-online.name_servers[2],
    aws_route53_zone.luga-online.name_servers[3]
  ]
}

resource "aws_route53_record" "google-mx" {
  allow_overwrite = true
  zone_id = aws_route53_zone.luga-online.zone_id
  name = "luga.online."
  type = "MX"
  ttl = "300"

  records = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM"
  ]
}

resource "aws_route53_record" "aws-soa" {
  allow_overwrite = true
  zone_id = aws_route53_zone.luga-online.zone_id
  name = "luga.online."
  type = "SOA"
  ttl = "300"

  records = [
    "ns-328.awsdns-41.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

resource "aws_route53_record" "google-site-verification-txt" {
  allow_overwrite = true
  zone_id = aws_route53_zone.luga-online.zone_id
  name = "luga.online."
  type = "TXT"
  ttl = "300"

  records = [
    "google-site-verification=kBRsC-INSkmMBRrH9yQceiVmhMUCiXLHBZFqzzVn3fo"
  ]
}

