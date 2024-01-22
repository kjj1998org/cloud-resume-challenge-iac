output "region" {
  value       = aws_s3_bucket.example.region
  description = "Region of the example bucket"
}

output "website-endpoint" {
  value       = aws_s3_bucket_website_configuration.example.website_endpoint
  description = "Website endpoint"
}