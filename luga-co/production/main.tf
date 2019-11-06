terraform {
  backend "s3" {
    bucket = "haplo-terraform-remote-state"
    key = "state"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
  shared_credentials_file = "/Users/gavanlamb/.aws/Credentials"
  profile = "default"
}

resource "aws_route53_zone" "luga-co" {
  name = "luga.co."
}

resource "aws_route53_record" "ns" {
  allow_overwrite = true
  zone_id = aws_route53_zone.luga-co.zone_id
  name = "luga.co."
  type = "NS"
  ttl = "300"

  records = [
    aws_route53_zone.luga-co.name_servers[0],
    aws_route53_zone.luga-co.name_servers[1],
    aws_route53_zone.luga-co.name_servers[2],
    aws_route53_zone.luga-co.name_servers[3]
  ]
}

resource "aws_route53_record" "aws-soa" {
  allow_overwrite = true
  zone_id = aws_route53_zone.luga-co.zone_id
  name = "luga.co."
  type = "SOA"
  ttl = "300"

  records = [
    "ns-1474.awsdns-56.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

resource "aws_route53_record" "google-mx" {
  allow_overwrite = true
  zone_id = aws_route53_zone.luga-co.zone_id
  name = "luga.co."
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

resource "aws_route53_record" "google-site-verification-txt" {
  allow_overwrite = true
  zone_id = aws_route53_zone.luga-co.zone_id
  name = "@.luga.co."
  type = "TXT"
  ttl = "300"

  records = [
    "google-site-verification=9aIjH0n50JOjjWW9Gef7S5n5qeh3GVBb49mjjBu7fcc"
  ]
}

output "zone-id" {
  value = aws_route53_zone.luga-co.zone_id
}
output "domain" {
  value = substr(aws_route53_zone.luga-co.name, 0, length(aws_route53_zone.luga-co.name)-1)
}
