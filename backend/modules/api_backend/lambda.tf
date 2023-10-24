# Generate pytube libreary layer zip file
data "archive_file" "d_pytube_layer" {
  type        = "zip"
  source_dir = "${path.root}/modules/api_backend/documents/lambda/pytube/layer/"
  output_path = "${path.root}/modules/api_backend/documents/lambda_layer.zip"
}

# Create pytube libreary layer
resource "aws_lambda_layer_version" "r_pytube_layer" {
  filename   = "${path.root}/modules/api_backend/documents/lambda_layer.zip"
  layer_name = "pytube"
  compatible_runtimes = ["python3.11"]
}

# Generate get_ytd_object lambda zip file
data "archive_file" "d_get_ytd_object" {
  type        = "zip"
  source_file = "${path.root}/modules/api_backend/documents/lambda/get_ytd_object.py"
  output_path = "${path.root}/modules/api_backend/documents/lambda/get_ytd_object.zip"
}

# Create get_ytd_object lambda
resource "aws_lambda_function" "r_get_ytd_object" {

  filename      = "${path.root}/modules/api_backend/documents/lambda/get_ytd_object.zip"
  function_name = "get_ytd_object"
  role          = aws_iam_role.r_role_get_ytd_object.arn
  handler       = "get_ytd_object.get_ytd_object"
  timeout = 900
  source_code_hash = data.archive_file.d_get_ytd_object.output_base64sha256
  layers = [aws_lambda_layer_version.r_pytube_layer.arn]
  runtime = "python3.11"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# Generate download_ytd_object lambda zip file
data "archive_file" "d_download_ytd_object" {
  type        = "zip"
  source_file = "${path.root}/modules/api_backend/documents/lambda/download_ytd_object.py"
  output_path = "${path.root}/modules/api_backend/documents/lambda/download_ytd_object.zip"
}

# Create download_ytd_object lambda
resource "aws_lambda_function" "r_download_ytd_object" {

  filename      = "${path.root}/modules/api_backend/documents/lambda/download_ytd_object.zip"
  function_name = "download_ytd_object"
  role          = aws_iam_role.r_role_download_ytd_object.arn
  handler       = "download_ytd_object.download_ytd_object"
  timeout = 900
  source_code_hash = data.archive_file.d_download_ytd_object.output_base64sha256
  layers = [aws_lambda_layer_version.r_pytube_layer.arn]
  runtime = "python3.11"

  environment {
    variables = {
      CLOUD_FRONT = "${var.v_backend_cloudfront_distribution_url}"
      DOWNLOAD_DIR = "/tmp"
      S3_BUCKET_NAME = "${var.v_backend_s3_bkt_name}"
      S3_FOLDER_NAME = "videos/"
    }
  }
}