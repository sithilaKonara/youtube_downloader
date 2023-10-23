# data source to generate bucket policy to let OAI get objects:
data "aws_iam_policy_document" "d_bucket_policy_document" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.r_ytd_web_s3.arn,
      "${aws_s3_bucket.r_ytd_web_s3.arn}/*"
    ]
  }
}