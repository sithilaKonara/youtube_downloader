
resource "aws_api_gateway_rest_api" "r_ytd_api_gateway" {
  name = "ytd_gateway"
}

resource "aws_api_gateway_resource" "r_ytd_root" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "r_get" {
  rest_api_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id   = aws_api_gateway_resource.r_ytd_root.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "r_post" {
  rest_api_id   = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id   = aws_api_gateway_resource.r_ytd_root.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "r_options" {
  rest_api_id      = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id      = aws_api_gateway_resource.r_ytd_root.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "r_get_lambda" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_ytd_root.id
  http_method = aws_api_gateway_method.r_get.http_method
  type        = "AWS_PROXY"
  integration_http_method = "GET"
  uri = aws_lambda_function.r_get_ytd_object.invoke_arn
}

resource "aws_api_gateway_integration" "r_post_lambda" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_ytd_root.id
  http_method = aws_api_gateway_method.r_post.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.r_download_ytd_object.invoke_arn
}

resource "aws_api_gateway_integration" "r_options_mock" {
  rest_api_id          = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id          = aws_api_gateway_resource.r_ytd_root.id
  http_method          = aws_api_gateway_method.r_options.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "r_options_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_ytd_root.id
  http_method = aws_api_gateway_method.r_options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "r_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_ytd_root.id
  http_method = aws_api_gateway_integration.r_options_mock.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "r_get_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_ytd_root.id
  http_method = aws_api_gateway_method.r_get.http_method
  status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"
#   }
}

resource "aws_api_gateway_method_response" "r_post_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_ytd_root.id
  http_method = aws_api_gateway_method.r_post.http_method
  status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"
#   }
}

resource "aws_api_gateway_integration_response" "r_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_ytd_root.id
  http_method = aws_api_gateway_method.r_get.http_method
  status_code = aws_api_gateway_method_response.r_get_response.status_code
}

resource "aws_api_gateway_integration_response" "r_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.r_ytd_api_gateway.id
  resource_id = aws_api_gateway_resource.r_ytd_root.id
  http_method = aws_api_gateway_method.r_post.http_method
  status_code = aws_api_gateway_method_response.r_post_response.status_code
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


resource "aws_lambda_permission" "r_api_gateway_get" {
  statement_id  = "AllowExecutionFromAPIGatewayGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.r_get_ytd_object.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.r_ytd_api_gw_deployment.execution_arn}/GET/get_ytd_object"
  depends_on = [ aws_api_gateway_integration.aws_api_gateway_integration.r_get_lambda ]
}

resource "aws_lambda_permission" "r_api_gateway_post" {
  statement_id  = "AllowExecutionFromAPIGatewayPost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.r_download_ytd_object.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.r_ytd_api_gw_deployment.execution_arn}/POST/download_ytd_object"
  depends_on = [ aws_api_gateway_integration.aws_api_gateway_integration.r_post_lambda ]
}

output "o_api_gateway_url" {
  value = aws_api_gateway_deployment.r_ytd_api_gw_deployment.invoke_url
}