
resource "aws_api_gateway_rest_api" "r_ytd_api_gateway" {
  name = "ytd_gateway"
}

resource "aws_api_gateway_resource" "r_ytd_root" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.root_resource_id
  path_part   = "ytd"
}

resource "aws_api_gateway_resource" "r_get_ytd" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  parent_id   = aws_api_gateway_resource.r_ytd_root.id
  path_part   = "ytd_get"
}

resource "aws_api_gateway_resource" "r_download_ytd" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  parent_id   = aws_api_gateway_resource.r_ytd_root.id
  path_part   = "ytd_download"
}

resource "aws_api_gateway_method" "r_get_ytd_method" {
  rest_api_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id   = aws_api_gateway_resource.r_get_ytd.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "r_download_ytd_method" {
  rest_api_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id   = aws_api_gateway_resource.r_download_ytd.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "r_get_ytd_lambda" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_get_ytd.id
  http_method = aws_api_gateway_method.r_get_ytd_method.http_method
  type        = "AWS"
  integration_http_method = "POST"
  uri = aws_lambda_function.r_get_ytd_object.invoke_arn
}

resource "aws_api_gateway_integration" "r_download_ytd_lambda" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_download_ytd.id
  http_method = aws_api_gateway_method.r_download_ytd_method.http_method
  type        = "AWS"
  integration_http_method = "POST"
  uri = aws_lambda_function.r_download_ytd_object.invoke_arn
}

resource "aws_api_gateway_method_response" "r_get_ytd_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_get_ytd.id
  http_method = aws_api_gateway_method.r_get_ytd_method.http_method
  status_code = "200"

  response_parameters = {
      "method.response.header.Access-Control-Allow-Headers"     = true,
      "method.response.header.Access-Control-Allow-Methods"     = true,
      "method.response.header.Access-Control-Allow-Origin"      = true,
      "method.response.header.Access-Control-Allow-Credentials" = true
    }
}

resource "aws_api_gateway_method_response" "r_download_ytd_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_download_ytd.id
  http_method = aws_api_gateway_method.r_download_ytd_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration_response" "r_get_ytd_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_get_ytd.id
  http_method = aws_api_gateway_method.r_get_ytd_method.http_method
  status_code = aws_api_gateway_method_response.r_get_ytd_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"      = "'*'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

resource "aws_api_gateway_integration_response" "r_download_ytd_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_download_ytd.id
  http_method = aws_api_gateway_method.r_download_ytd_method.http_method
  status_code = aws_api_gateway_method_response.r_download_ytd_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"      = "'*'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }
}


# =======================================================

resource "aws_api_gateway_method" "r_get_ytd_method_option" {
  rest_api_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id   = aws_api_gateway_resource.r_get_ytd.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "r_download_ytd_method_option" {
  rest_api_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id   = aws_api_gateway_resource.r_download_ytd.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "r_get_ytd_option" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_get_ytd.id
  http_method = aws_api_gateway_method.r_get_ytd_method_option.http_method
  type        = "MOCK"
  integration_http_method = "OPTIONS"
  request_templates = {
    "application/json" = <<EOF
      {
        "statusCode" : 200
      }
      EOF
  }
}

resource "aws_api_gateway_integration" "r_download_ytd_option" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_download_ytd.id
  http_method = aws_api_gateway_method.r_download_ytd_method_option.http_method
  type        = "MOCK"
  integration_http_method = "OPTIONS"
  request_templates = {
    "application/json" = <<EOF
      {
        "statusCode" : 200
      }
      EOF
  }

}

resource "aws_api_gateway_method_response" "r_get_ytd_response_option" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_get_ytd.id
  http_method = aws_api_gateway_method.r_get_ytd_method_option.http_method
  status_code = "200"

  response_parameters = {
      "method.response.header.Access-Control-Allow-Headers"     = true,
      "method.response.header.Access-Control-Allow-Methods"     = true,
      "method.response.header.Access-Control-Allow-Origin"      = true
    }
}

resource "aws_api_gateway_method_response" "r_download_ytd_response_option" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_download_ytd.id
  http_method = aws_api_gateway_method.r_download_ytd_method_option.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
  }
}

resource "aws_api_gateway_integration_response" "r_get_ytd_integration_response_option" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_get_ytd.id
  http_method = aws_api_gateway_method.r_get_ytd_method_option.http_method
  status_code = aws_api_gateway_method_response.r_get_ytd_response_option.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "r_download_ytd_integration_response_option" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_download_ytd.id
  http_method = aws_api_gateway_method.r_download_ytd_method_option.http_method
  status_code = aws_api_gateway_method_response.r_download_ytd_response_option.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
  }
}








resource "aws_api_gateway_deployment" "r_ytd_api_gw_deployment" {  
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  stage_name = "test"
#   depends_on = [aws_api_gateway_integration.get_lambda, aws_api_gateway_integration.post_lambda]
}

resource "aws_api_gateway_stage" "r_api_gw_stage" {
  stage_name    = aws_api_gateway_deployment.r_ytd_api_gw_deployment.stage_name
  rest_api_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  deployment_id = aws_api_gateway_deployment.r_ytd_api_gw_deployment.id
}


resource "aws_lambda_permission" "r_api_gateway_get_ytd" {
  statement_id  = "AllowExecutionFromAPIGatewayGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.r_get_ytd_object.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.v_backend_region_id}:${var.v_backend_account_id}:${aws_api_gateway_rest_api.r_ytd_api_gateway.id}/*/${aws_api_gateway_method.r_get_ytd_method.http_method}${aws_api_gateway_resource.r_get_ytd.path}"
  depends_on = [ 
    aws_api_gateway_integration.r_get_ytd_lambda,
    aws_api_gateway_stage.r_api_gw_stage
  ]
}

resource "aws_lambda_permission" "r_api_gateway_download_ytd" {
  statement_id  = "AllowExecutionFromAPIGatewayPost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.r_download_ytd_object.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.v_backend_region_id}:${var.v_backend_account_id}:${aws_api_gateway_rest_api.r_ytd_api_gateway.id}/*/${aws_api_gateway_method.r_download_ytd_method.http_method}${aws_api_gateway_resource.r_download_ytd.path}"
  depends_on = [ 
    aws_api_gateway_integration.r_download_ytd_lambda,
    aws_api_gateway_stage.r_api_gw_stage
  ]
}

output "o_api_gateway_url" {
  value = aws_api_gateway_deployment.r_ytd_api_gw_deployment.invoke_url
}