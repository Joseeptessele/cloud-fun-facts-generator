###############################################################
# dynamodb.tf - DynamoDB Table Configuration
###############################################################

resource "aws_dynamodb_table" "cloud_facts" {
  name             = "CloudFacts"
  billing_mode     = "PROVISIONED"
  read_capacity    = 1
  write_capacity   = 1
  hash_key         = "FactID"
  range_key        = "FactText"

  attribute {
    name = "FactID"
    type = "S"
  }

  attribute {
    name = "FactText"
    type = "S"
  }

  tags = var.tags
}
