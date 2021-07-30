data "aws_iam_policy_document" "lambda_route53_backup_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "route53:GetHealthCheck",
      "route53:ListHealthChecks",
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
      "route53:ListTagsForResources",
    ]
    resources = [
      "*"
    ]
  }

  statement { 
     
       effect = "Allow"
       actions = ["s3:*"]
       resources = [
         data.aws_s3_bucket.backup_sink.arn, 
         "${data.aws_s3_bucket.backup_sink.arn}/*"
         ]
  }
}

data "aws_iam_policy_document" "lambda_route53_restore_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "route53:GetHealthCheck",
      "route53:ListHealthChecks",
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
      "route53:ListTagsForResources",
      "route53:CreateHostedZone",
      "route53:GetHealthCheck",
      "route53:ChangeResourceRecordSets",
      "route53:ListTagsForResource",
      "route53:ListTagsForResources",
      "route53:CreateHealthCheck",
      "route53:AssociateVPCWithHostedZone",
      "route53:ChangeTagsForResource",
      "ec2:DescribeVpcs",
    ]
    resources = [
      "*"
    ]
  }
}
