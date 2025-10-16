output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.main.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.main.function_name
}

output "lambda_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda_role.arn
}

output "api_gateway_url" {
  description = "API Gateway URL"
  value       = var.enable_api_gateway ? aws_apigatewayv2_api.main[0].api_endpoint : null
}

output "function_url" {
  description = "Lambda Function URL"
  value       = var.enable_function_url ? aws_lambda_function_url.main[0].function_url : null
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group name"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}