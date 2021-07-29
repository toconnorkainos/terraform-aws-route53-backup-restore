resource "aws_kms_key" "route53_key" {
  description = local.aws_account_level_module_id

  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.route53_key.json
  enable_key_rotation     = true

  tags = merge(
    local.default_tags,
    map(
      "Name", local.aws_account_level_module_id,
    ),
  )
}
