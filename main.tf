terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "root_domain_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name = "jjkoh2.net"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "My root domain bucket"
  }
}

module "subdomain_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name = "www.jjkoh2.net"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "My subdomain bucket"
  }
}

resource "aws_s3_object" "index" {
  bucket       = module.root_domain_s3_bucket.name
  key          = "resume.html"
  source       = "./resume.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = module.root_domain_s3_bucket.name
  key          = "error.html"
  source       = "./error.html"
  content_type = "text/html"
}