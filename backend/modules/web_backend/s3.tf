resource "aws_s3_bucket" "r_ytd_web_s3" {
  bucket = "youtube-downloader-web"
}

# add bucket policy to let the CloudFront OAI get objects:
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.r_ytd_web_s3.id
  policy = data.aws_iam_policy_document.d_bucket_policy_document.json
}