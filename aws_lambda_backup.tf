data "archive_file" "lambda_zip_inline_LambdaFunctionRoute53Backup" {
  type        = "zip"
  output_path = "/tmp/lambda_zip_inlinetmpfileLambdaFunctionRoute53Backup.zip"
  source_dir  = "${path.module}/code"
}

resource "aws_lambda_function" "LambdaFunctionRoute53Backup" {
  function_name    = "LambdaFunctionForRoute53Backup"
  timeout          = "300"
  runtime          = "python3.8"
  handler          = "backup_route53.handle"
  role             = aws_iam_role.LambdaIamRoleRoute53Backup.arn
  filename         = data.archive_file.lambda_zip_inline_LambdaFunctionRoute53Backup.output_path
  source_code_hash = data.archive_file.lambda_zip_inline_LambdaFunctionRoute53Backup.output_base64sha256

  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
      AWS_REGION     = data.aws_region.current.name
    }
  }
  tags = merge(
    var.tags,
    map(
      "Creator", "Managed by Terraform",
    ),
  )
}

resource "aws_lambda_function" "LambdaFunctionRoute53Restore" {
  function_name    = "LambdaFunctionForRoute53Restore"
  timeout          = "300"
  runtime          = "python3.8"
  handler          = "restore_route53.handle"
  role             = aws_iam_role.LambdaIamRoleRoute53Backup.arn
  filename         = data.archive_file.lambda_zip_inline_LambdaFunctionRoute53Backup.output_path
  source_code_hash = data.archive_file.lambda_zip_inline_LambdaFunctionRoute53Backup.output_base64sha256

  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
      AWS_REGION     = data.aws_region.current.name
    }
  }
  tags = merge(
    var.tags,
    map(
      "Creator", "Managed by Terraform",
    ),
  )
}

resource "aws_cloudwatch_event_rule" "trigger_backup_rule" {
  name                = "capture-route53-events"
  description         = "Schedule to trigger route53 backup"
  schedule_expression = "rate(${var.interval} minutes)"
  tags = merge(
    var.tags,
    map(
      "Creator", "Managed by Terraform",
    ),
  )
}

resource "aws_cloudwatch_event_target" "trigger_Route53_backup_event" {
  rule      = aws_cloudwatch_event_rule.trigger_backup_rule.name
  target_id = "lambda"
  arn       = aws_lambda_function.LambdaFunctionRoute53Backup.arn
}

resource "aws_lambda_permission" "allow_to_call_route53_backup" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaFunctionRoute53Backup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger_backup_rule.arn
}
