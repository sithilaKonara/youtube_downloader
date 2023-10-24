resource "aws_cloudfront_origin_access_control" "r_ytd_web_cfoac" {
  name                              = "example"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "myS3Origin"
}


resource "aws_cloudfront_distribution" "r_ytd_web_cf" {
  origin {
    domain_name              = aws_s3_bucket.r_ytd_web_s3.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.r_ytd_web_cfoac.id
    origin_id                = local.s3_origin_id
  }

  staging             = true
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Testing CloudFront destribution"
  default_root_object = "index.html"
  price_class = "PriceClass_200"

#   aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods   = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    target_origin_id = local.s3_origin_id
  }  

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "test"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}