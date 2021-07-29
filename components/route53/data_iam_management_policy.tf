data "aws_iam_policy_document" "lambda_route53_backup_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "iam:DeleteAccessKey",
      "iam:DeleteLoginProfile",
      "iam:DeleteSigningCertificate",
      "iam:DeleteServiceSpecificCredential",
      "iam:DeleteUserPolicy",
      "iam:DetachUserPolicy",
      "iam:DeleteUser",
      "iam:GetAccessKeyLastUsed",
      "iam:GetLoginProfile",
      "iam:GetUser",
      "iam:RemoveUserFromGroup",
      "iam:DeleteSSHPublicKey",
      "iam:List*",
      "iam:TagUser",
      "iam:UntagUser",
      "iam:UpdateAccessKey"
    ]
    resources = [
      "*"
    ]
  }
}
