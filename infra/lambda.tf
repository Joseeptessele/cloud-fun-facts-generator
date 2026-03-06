resource "aws_lambda_function" "cloud_fun_facts" {
  function_name = "${var.project_name}-function"
  description   = "Lambda function invocada pelo API Gateway"

  filename         = "${path.module}/../app/aws_facts_lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../app/aws_facts_lambda.zip")

  runtime = var.lambda_runtime
  handler = var.lambda_handler

  role = aws_iam_role.lambda_exec.arn

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  environment {
    variables = var.lambda_env_vars
  }

  tags = var.tags
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.cloud_fun_facts.function_name}"
  retention_in_days = 14
  tags              = var.tags
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/../app/aws_facts_lambda.zip"
}
