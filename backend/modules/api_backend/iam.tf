# Create IAM role for get_ytd_object lambda
resource "aws_iam_role" "r_role_get_ytd_object" {
  name = "role_${var.v_api_backend_app_name}_get_ytd_object"
  inline_policy {
    name = "inline_policy"
    policy = data.aws_iam_policy_document.d_get_ytd_object.json
  }
  assume_role_policy = data.aws_iam_policy_document.d_lambda_assume_role.json
}

# Create IAM role for download_ytd_object lambda
resource "aws_iam_role" "r_role_download_ytd_object" {
  name = "role_${var.v_api_backend_app_name}_download_ytd_object"
  inline_policy {
    name = "inline_policy"
    policy = data.aws_iam_policy_document.d_download_ytd_object.json
  }
  assume_role_policy = data.aws_iam_policy_document.d_lambda_assume_role.json
}