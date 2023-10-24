# data source to generate bucket policy to let OAI get objects:
data "aws_iam_policy_document" "d_bucket_policy_document" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    resources = ["${aws_s3_bucket.r_ytd_web_s3.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudfront::554353511998:distribution/${aws_cloudfront_distribution.r_ytd_web_cf.id}"]
    }
  }
}