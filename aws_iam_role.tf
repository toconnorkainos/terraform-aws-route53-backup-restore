resource "aws_iam_role" "LambdaIamRoleRoute53Backup" {
  name               = "LambdaIamRoleRoute53Backup"
  assume_role_policy = data.aws_iam_policy_document.lambda_assumerole.json
  tags = merge(
    local.default_tags,
    map(
      "Creator", "Managed by Terraform",
    ),
  )
}

resource "aws_iam_policy" "route53_backup_policy" {
  name   = "route53_backup_policy"
  path   = "/automation/lambda/route53-backup/"
  policy = data.aws_iam_policy_document.lambda_route53_backup_policy_doc.json
}


resource "aws_iam_policy" "route53_restore_policy" {
  name   = "route53_restore_policy"
  path   = "/automation/lambda/route53-restore/"
  policy = data.aws_iam_policy_document.lambda_route53_restore_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "LambdaIamRoleConfig_att0" {
  role       = aws_iam_role.LambdaIamRoleRoute53Backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "LambdaIamRoleConfig_att1" {
  role       = aws_iam_role.LambdaIamRoleRoute53Backup.name
  policy_arn = aws_iam_policy.route53_backup_policy.arn
}

resource "aws_iam_role_policy_attachment" "LambdaIamRoleConfig_att2" {
  role       = aws_iam_role.LambdaIamRoleRoute53Backup.name
  policy_arn = aws_iam_policy.route53_restore_policy.arn
}


