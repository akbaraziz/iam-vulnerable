resource "aws_iam_policy" "privesc7-AttachUserPolicy" {
  name        = "privesc7-AttachUserPolicy"
  path        = "/"
  description = "Allows privesc via iam:AttachUserPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AttachUserPolicy"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "8a2d2678-4d6f-4ac5-a7b6-b5aae94e5907"
  }
}

resource "aws_iam_role" "privesc7-AttachUserPolicy-role" {
  name = "privesc7-AttachUserPolicy-role"
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
    yor_trace = "75eed056-8844-48dd-acb4-81dd8e080bc3"
  }
}

resource "aws_iam_user" "privesc7-AttachUserPolicy-user" {
  name = "privesc7-AttachUserPolicy-user"
  path = "/"
  tags = {
    yor_trace = "500810e6-6508-423e-8340-e240aed0f54c"
  }
}

resource "aws_iam_access_key" "privesc7-AttachUserPolicy-user" {
  user = aws_iam_user.privesc7-AttachUserPolicy-user.name
}


resource "aws_iam_user_policy_attachment" "privesc7-AttachUserPolicy-user-attach-policy" {
  user       = aws_iam_user.privesc7-AttachUserPolicy-user.name
  policy_arn = aws_iam_policy.privesc7-AttachUserPolicy.arn
}

resource "aws_iam_role_policy_attachment" "privesc7-AttachUserPolicy-role-attach-policy" {
  role       = aws_iam_role.privesc7-AttachUserPolicy-role.name
  policy_arn = aws_iam_policy.privesc7-AttachUserPolicy.arn
}