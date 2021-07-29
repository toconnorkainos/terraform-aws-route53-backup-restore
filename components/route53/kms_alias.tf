resource "aws_kms_alias" "route53_key_alias" {
  name          = var.alias
  target_key_id = aws_kms_key.route53_key.key_id
}
