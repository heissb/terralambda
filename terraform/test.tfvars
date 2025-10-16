aws_region    = "us-east-1"
function_name = "network-status-api"
handler       = "bootstrap"
runtime       = "provided.al2023"
timeout       = 30
memory_size   = 256

environment_variables = {
  ENVIRONMENT = "production"
  LOG_LEVEL   = "info"
}

enable_api_gateway  = true
enable_function_url = false
enable_vpc          = false
enable_alarms       = true

cors_allowed_origins = ["*"]

tags = {
  Project     = "NetworkStatus"
  Environment = "production"
  ManagedBy   = "terraform"
}