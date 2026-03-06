###############################################################
# variables.tf
###############################################################

variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "sa-east-1"
}

variable "project_name" {
  description = "Nome base do projeto (usado como prefixo nos recursos)"
  type        = string
  default     = "CloudFunFacts"
}

variable "api_stage_name" {
  description = "Nome do stage do API Gateway"
  type        = string
}

# ─── Lambda ───────────────────────────────────────────────────

variable "lambda_zip_path" {
  description = "Caminho local para o arquivo .zip com o código da Lambda"
  type        = string
  default     = "aws_facts_lambda.zip"
}

variable "lambda_runtime" {
  description = "Runtime da Lambda (ex: python3.11, nodejs20.x, java21)"
  type        = string
  default     = "python3.11"
}

variable "lambda_handler" {
  description = "Handler da Lambda no formato arquivo.função"
  type        = string
  default     = "aws_facts_lambda.lambda_handler"
}

variable "lambda_timeout" {
  description = "Timeout da Lambda em segundos"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memória alocada para a Lambda em MB"
  type        = number
  default     = 128
}

variable "lambda_env_vars" {
  description = "Variáveis de ambiente injetadas na Lambda"
  type        = map(string)
  default     = {}
}

# ─── Tags ─────────────────────────────────────────────────────

variable "tags" {
  description = "Tags aplicadas em todos os recursos"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
  }
}
