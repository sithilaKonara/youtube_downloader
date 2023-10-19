data "archive_file" "d_pytube_layer" {
  type        = "zip"
  source_dir = "${path.root}/modules/api_backend/documents/lambda/pytube/layer/"
  output_path = "${path.root}/modules/api_backend/documents/lambda_layer.zip"
}

resource "aws_lambda_layer_version" "r_pytube_layer" {
  filename   = "${path.root}/modules/api_backend/documents/lambda_layer.zip"
  layer_name = "pytube_core"

  compatible_runtimes = ["python3.11"]
}