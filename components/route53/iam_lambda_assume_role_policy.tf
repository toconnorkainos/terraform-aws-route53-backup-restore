data "aws_iam_policy_document" "lambda_assumerole" {
  statement {
    sid    = "AllowAssumeRole"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}