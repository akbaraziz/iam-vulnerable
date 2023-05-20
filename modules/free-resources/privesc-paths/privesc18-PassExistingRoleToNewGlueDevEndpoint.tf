resource "aws_iam_policy" "privesc18-PassExistingRoleToNewGlueDevEndpoint" {
  name        = "privesc18-PassExistingRoleToNewGlueDevEndpoint"
  path        = "/"
  description = "Allows privesc via glue:CreateDevEndpoint, glue:GetDevEndpoint and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:CreateDevEndpoint",
          "glue:GetDevEndpoint",
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "f24ed094-c6f3-469a-b060-484fac14b0f6"
  }
}

resource "aws_iam_role" "privesc18-PassExistingRoleToNewGlueDevEndpoint-role" {
  name = "privesc18-PassExistingRoleToNewGlueDevEndpoint-role"
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
    yor_trace = "35852046-3e80-4515-ac6e-f4733682aa2d"
  }
}

resource "aws_iam_user" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user" {
  name = "privesc18-PassExistingRoleToNewGlueDevEndpoint-user"
  path = "/"
  tags = {
    yor_trace = "0a0e2571-0376-46cf-8e98-af1e1c542da2"
  }
}

resource "aws_iam_access_key" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user" {
  user = aws_iam_user.privesc18-PassExistingRoleToNewGlueDevEndpoint-user.name
}


resource "aws_iam_user_policy_attachment" "privesc18-PassExistingRoleToNewGlueDevEndpoint-user-attach-policy" {
  user       = aws_iam_user.privesc18-PassExistingRoleToNewGlueDevEndpoint-user.name
  policy_arn = aws_iam_policy.privesc18-PassExistingRoleToNewGlueDevEndpoint.arn
}

resource "aws_iam_role_policy_attachment" "privesc18-PassExistingRoleToNewGlueDevEndpoint-role-attach-policy" {
  role       = aws_iam_role.privesc18-PassExistingRoleToNewGlueDevEndpoint-role.name
  policy_arn = aws_iam_policy.privesc18-PassExistingRoleToNewGlueDevEndpoint.arn
}
