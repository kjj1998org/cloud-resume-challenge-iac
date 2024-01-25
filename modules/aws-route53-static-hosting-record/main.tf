data "aws_route53_zone" "route53_zone" {
  name         = var.route53_zone_name
  private_zone = false
}


resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.subdomain_alias_record_status ? "www.${data.aws_route53_zone.route53_zone.name}" : data.aws_route53_zone.route53_zone.name
  
  type    = var.route53_record_type
  
  alias {
    name                   = data.aws_s3_bucket.selected.website_domain
    zone_id                = data.aws_s3_bucket.selected.hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_s3_bucket" "selected" {
  bucket = var.s3_bucket_name
}