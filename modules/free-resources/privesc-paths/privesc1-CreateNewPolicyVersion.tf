resource "aws_iam_policy" "privesc1-CreateNewPolicyVersion" {
  name        = "privesc1-CreateNewPolicyVersion"
  path        = "/"
  description = "Allows privesc via iam:CreatePolicyVersion"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:CreatePolicyVersion"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "fa1090f6-3a3a-4e06-88a8-067efc86157e"
  }
}

resource "aws_iam_role" "privesc1-CreateNewPolicyVersion-role" {
  name = "privesc1-CreateNewPolicyVersion-role"
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
    yor_trace = "0c37e88b-abd4-4344-a44c-41df7bd95811"
  }
}


resource "aws_iam_user" "privesc1-CreateNewPolicyVersion-user" {
  name = "privesc1-CreateNewPolicyVersion-user"
  path = "/"
  tags = {
    yor_trace = "8f4424a7-10b5-48bf-b100-358e727ddad5"
  }
}

resource "aws_iam_access_key" "privesc1-CreateNewPolicyVersion-user" {
  user = aws_iam_user.privesc1-CreateNewPolicyVersion-user.name
}


resource "aws_iam_user_policy_attachment" "privesc1-CreateNewPolicyVersion-user-attach-policy" {
  user       = aws_iam_user.privesc1-CreateNewPolicyVersion-user.name
  policy_arn = aws_iam_policy.privesc1-CreateNewPolicyVersion.arn
}

resource "aws_iam_role_policy_attachment" "privesc1-CreateNewPolicyVersion-role-attach-policy" {
  role       = aws_iam_role.privesc1-CreateNewPolicyVersion-role.name
  policy_arn = aws_iam_policy.privesc1-CreateNewPolicyVersion.arn

}  