locals {
  # GENERAL
  aws_account_level_id = format(
    "%s-%s-%s",
    var.project,
    var.environment,
    var.component,
  )

  aws_global_level_id = format(
    "%s-%s-%s-%s",
    var.project,
    data.aws_caller_identity.current.account_id,
    var.environment,
    var.component,
  )

  aws_bucket_access_log = format(
    "%s-%s-%s",
    var.project,
    data.aws_caller_identity.current.account_id,
    var.environment,
  )


  default_tags = {
    Project     = var.project
    Environment = var.environment
    Component   = var.component
  }

  aws_account_level_module_id = local.aws_account_level_id
}
