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

  source_code_hash = data.archive_file.d_get_ytd_object.output_base64sha256

  runtime = "python3.11"

  environment {
    variables = {
      foo = "bar"
    }
  }
}