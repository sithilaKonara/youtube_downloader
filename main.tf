resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test111111-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}