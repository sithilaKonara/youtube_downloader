output "o_cloudfront_distribution_url" {
  value = aws_cloudfront_distribution.r_ytd_web_cf.domain_name
}

output "o_s3_bkt_name" {
  value = aws_s3_bucket.r_ytd_web_s3.id
}