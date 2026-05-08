output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_bucket_id" {
  value = aws_s3_bucket.website.id
}
