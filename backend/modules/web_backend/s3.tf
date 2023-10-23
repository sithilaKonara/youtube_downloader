resource "aws_s3_bucket" "r_ytd_web_s3" {
  bucket = "youtube-downloader-web"
}

resource "aws_s3_bucket_acl" "r_bkt_acl" {
  bucket = aws_s3_bucket.r_ytd_web_s3.id
  acl    = "private"
}
