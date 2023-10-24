data "aws_iam_policy_document" "d_get_ytd_object" {
  statement {
    effect = "Allow"
    actions = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${var.v_backend_region_id}:${var.v_backend_account_id}:*"]
  }
  statement {
    effect = "Allow"
    actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${var.v_backend_region_id}:${var.v_backend_account_id}:log-group:/aws/lambda/get_ytd_object:*"]
  }
}

data "aws_iam_policy_document" "d_download_ytd_object" {
  statement {
    effect = "Allow"
    actions = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${var.v_backend_region_id}:${var.v_backend_account_id}:*"]
  }
  statement {
    effect = "Allow"
    actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${var.v_backend_region_id}:${var.v_backend_account_id}:log-group:/aws/lambda/download_ytd_object:*"]
  }
   statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${var.v_backend_s3_bkt_name}/video/",
      "arn:aws:s3:::${var.v_backend_s3_bkt_name}/video/*"
    ]
  }
}


# Lambda assume role policy
data "aws_iam_policy_document" "d_lambda_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}