data "archive_file" "lambda_zip_inline_LambdaFunctionRoute53Backup" {
  type        = "zip"
  output_path = "/tmp/lambda_zip_inlinetmpfileLambdaFunctionRoute53Backup.zip"
  source_file = "${path.module}/code/backup_route53.py"
}

resource "aws_lambda_function" "LambdaFunctionRoute53Backup" {
  function_name    = "LambdaFunctionForRoute53Backup"
  timeout          = "300"
  runtime          = "python3.8"
  handler          = "index.lambda_handler"
  role             = aws_iam_role.LambdaIamRoleRoute53Backup.arn
  filename         = data.archive_file.lambda_zip_inline_LambdaFunctionRoute53Backup.output_path
  source_code_hash = data.archive_file.lambda_zip_inline_LambdaFunctionRoute53Backup.output_base64sha256
 # layers           = [data.aws_lambda_layer_version.notify_client.arn]

  environment {
    variables = {
      DEBUG            = "false"
      AWS_ENVIRONMENT  = var.environment
      AWS_ACCOUNT_NAME = "nhs-${var.environment} - ${data.aws_caller_identity.current.account_id}"
    }
  }
  tags = merge(
    local.default_tags,
    map(
      "Creator", "Managed by Terraform",
    ),
  )
}

resource "aws_cloudwatch_event_rule" "route53_events" {
  name          = "capture-route53-events"
  description   = "CloudWatch event rule to trigger CloudTrail-Route53 changes"
  event_pattern = data.template_file.event_pattern.rendered
    tags = merge(
    local.default_tags,
    map(
      "Creator", "Managed by Terraform",
    ),
  ) 
}

data "template_file" "event_pattern" { template = file("${path.module}/files/event_pattern.tpl") }

resource "aws_cloudwatch_event_target" "trigger_Route53_backup_event" {
  rule      = aws_cloudwatch_event_rule.route53_events.name
  target_id = "lambda"
  arn       = aws_lambda_function.LambdaFunctionRoute53Backup.arn
}

resource "aws_lambda_permission" "allow_to_call_route53_backup" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaFunctionRoute53Backup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.route53_events.arn
}