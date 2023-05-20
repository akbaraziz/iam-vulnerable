resource "aws_iam_policy" "privesc-CloudFormationUpdateStack" {
  name        = "privesc-CloudFormationUpdateStack"
  path        = "/"
  description = "Allows privesc via cloudformation:UpdateStack"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:UpdateStack",
          "cloudformation:DescribeStacks"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = {
    yor_trace = "d9834819-09de-490c-9c86-e5aac2560254"
  }
}

resource "aws_iam_role" "privesc-CloudFormationUpdateStack-role" {
  name = "privesc-CloudFormationUpdateStack-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = var.aws_assume_role_arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "dd814523-53d7-469e-8472-f237703fc070"
  }
}

resource "aws_iam_user" "privesc-CloudFormationUpdateStack-user" {
  name = "privesc-CloudFormationUpdateStack-user"
  path = "/"
  tags = {
    yor_trace = "ae2b92a1-3978-40f0-baae-703f3fa65b21"
  }
}

resource "aws_iam_access_key" "privesc-CloudFormationUpdateStack-user" {
  user = aws_iam_user.privesc-CloudFormationUpdateStack-user.name
}


resource "aws_iam_user_policy_attachment" "privesc-CloudFormationUpdateStack-user-attach-policy" {
  user       = aws_iam_user.privesc-CloudFormationUpdateStack-user.name
  policy_arn = aws_iam_policy.privesc-CloudFormationUpdateStack.arn
}

resource "aws_iam_role_policy_attachment" "privesc-CloudFormationUpdateStack-role-attach-policy" {
  role       = aws_iam_role.privesc-CloudFormationUpdateStack-role.name
  policy_arn = aws_iam_policy.privesc-CloudFormationUpdateStack.arn
}
