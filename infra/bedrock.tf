###############################################################
# bedrock.tf - AWS Bedrock Configuration
###############################################################

# IAM Role for Bedrock Agent
resource "aws_iam_role" "bedrock_agent_role" {
  name = "${var.project_name}-bedrock-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Policy for Bedrock Agent to invoke models
resource "aws_iam_role_policy" "bedrock_agent_policy" {
  name = "${var.project_name}-bedrock-agent-policy"
  role = aws_iam_role.bedrock_agent_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "arn:aws:bedrock:${var.aws_region}::foundation-model/anthropic.claude-3-5-sonnet-20241022-v2:0"
      }
    ]
  })
}

# Bedrock Agent for Claude 3.5 Sonnet
resource "aws_bedrock_agent" "cloud_facts_agent" {
  agent_name             = "${var.project_name}-agent"
  agent_resource_role_arn = aws_iam_role.bedrock_agent_role.arn
  idle_session_ttl_in_seconds = 600
  foundation_model       = "anthropic.claude-3-5-sonnet-20241022-v2:0"
  
  description = "Bedrock Agent powered by Claude 3.5 Sonnet for Cloud Fun Facts"

  tags = var.tags
}

