# Create IAM role for get_ytd_object lambda
resource "aws_iam_role" "r_role_get_ytd_object" {
  name = "role_get_ytd_object"
  inline_policy {
    name = "inline_policy"
    policy = data.aws_iam_policy_document.d_get_ytd_object.json
  }
  assume_role_policy = data.aws_iam_policy_document.d_lambda_assume_role.json
}