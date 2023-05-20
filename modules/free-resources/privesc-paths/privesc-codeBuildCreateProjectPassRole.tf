resource "aws_iam_policy" "privesc-codeBuildCreateProjectPassRole-policy" {
  name        = "privesc-codeBuildCreateProjectPassRole-policy"
  path        = "/"
  description = "Allows privesc via codeBuild"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codebuild:CreateProject",
          "codebuild:StartBuild",
          "codebuild:StartBuildBatch",
          "iam:PassRole",
          "iam:ListRoles"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "3252abd4-3578-44d9-b211-b8242fab1fa3"
  }
}



resource "aws_iam_role" "privesc-codeBuildCreateProjectPassRole-role" {
  name = "privesc-codeBuildCreateProjectPassRole-role"
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
    yor_trace = "4b1887f8-b08f-44af-8b8e-689d95a609fb"
  }
}


resource "aws_iam_user" "privesc-codeBuildCreateProjectPassRole-user" {
  name = "privesc-codeBuildCreateProjectPassRole-user"
  path = "/"
  tags = {
    yor_trace = "2e423377-50d5-4fee-9644-419c7a735de9"
  }
}

resource "aws_iam_access_key" "privesc-codeBuildCreateProjectPassRole-user" {
  user = aws_iam_user.privesc-codeBuildCreateProjectPassRole-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-codeBuildCreateProjectPassRole-user-attach-policy" {
  user       = aws_iam_user.privesc-codeBuildCreateProjectPassRole-user.name
  policy_arn = aws_iam_policy.privesc-codeBuildCreateProjectPassRole-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-codeBuildCreateProjectPassRole-role-attach-policy" {
  role       = aws_iam_role.privesc-codeBuildCreateProjectPassRole-role.name
  policy_arn = aws_iam_policy.privesc-codeBuildCreateProjectPassRole-policy.arn

}

