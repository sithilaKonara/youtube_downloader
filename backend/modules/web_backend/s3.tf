resource "aws_s3_bucket" "r_ytd_web_s3" {
  bucket = "youtube-downloader-web"
}

resource "aws_s3_bucket_acl" "r_bkt_acl" {
  bucket = aws_s3_bucket.r_ytd_web_s3.id
  acl    = "private"
}

# create S3 website hosting:
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.r_ytd_web_s3.id
  index_document {
    suffix = "index.html"
  }
}
# add bucket policy to let the CloudFront OAI get objects:
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.r_ytd_web_s3.id
  policy = data.aws_iam_policy_document.d_bucket_policy_document.json
}