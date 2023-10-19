data "archive_file" "d_pytube_layer" {
  type        = "zip"
  source_file = "${path.root}/modules/api_backend/documents/lambda/pytube/venv/Lib/site-packages"
  output_path = "layer.zip"
}

resource "aws_lambda_layer_version" "r_pytube_layer" {
  filename   = "layer.zip"
  layer_name = "pytube_core"

  compatible_runtimes = ["python3.11"]
}