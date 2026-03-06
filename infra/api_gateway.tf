
##############################
# API Gateway (HTTP API v2)
##############################

resource "aws_apigatewayv2_api" "cloud_fun_facts" {
  name          = "${var.project_name}API"
  protocol_type = "HTTP"
  description   = "HTTP API Gateway para ${var.project_name}"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET"]
    max_age       = 300
  }

  tags = var.tags
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.cloud_fun_facts.id
  name        = var.api_stage_name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = "JSON"
  }


  tags = var.tags
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/${var.project_name}-api"
  retention_in_days = 14
  tags              = var.tags
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.cloud_fun_facts.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.cloud_fun_facts.invoke_arn
  integration_method = "GET"

  payload_format_version = "2.0"
}

##############################
# Rota: GET /funfact
##############################

resource "aws_apigatewayv2_route" "get_funfact" {
  api_id    = aws_apigatewayv2_api.cloud_fun_facts.id
  route_key = "GET /funfact"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

##############################
# Permissão: API Gateway invocar Lambda
##############################

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloud_fun_facts.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.cloud_fun_facts.execution_arn}/*/*"
}
