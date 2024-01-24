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

  bucket_name                  = "jjkoh2.net"
  s3_enable_bucket_policy      = true
  s3_block_public_access       = false
  s3_enable_logging            = true
  s3_target_bucket_for_logging = module.logging_s3_bucket.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "My root domain bucket"
  }

  depends_on = [module.logging_s3_bucket]
}

module "subdomain_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name               = "www.jjkoh2.net"
  s3_enable_bucket_policy   = false
  s3_block_public_access    = true
  s3_website_redirect       = true
  s3_redirect_requests_host = module.root_domain_s3_bucket.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "My subdomain bucket"
  }
}

module "logging_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name             = "logs.jjkoh2.net"
  s3_enable_bucket_policy = false
  s3_block_public_access  = true


  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "My logging bucket"
  }
}

resource "aws_s3_object" "logs_folder" {
  bucket = module.logging_s3_bucket.name
  key    = "logs/"

  depends_on = [module.logging_s3_bucket]
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