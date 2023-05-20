resource "aws_iam_policy" "privesc19-UpdateExistingGlueDevEndpoint" {
  name        = "privesc19-UpdateExistingGlueDevEndpoint"
  path        = "/"
  description = "Allows privesc via glue:UpdateDevEndpoint and glue:GetDevEndpoint"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:UpdateDevEndpoint",
          "glue:GetDevEndpoint"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "890aecba-62ce-4cad-a8e6-4675438251ed"
  }
}

resource "aws_iam_role" "privesc19-UpdateExistingGlueDevEndpoint-role" {
  name = "privesc19-UpdateExistingGlueDevEndpoint-role"
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
    yor_trace = "2a8b62b1-f221-42fc-a85f-fb370e4b3067"
  }
}

resource "aws_iam_user" "privesc19-UpdateExistingGlueDevEndpoint-user" {
  name = "privesc19-UpdateExistingGlueDevEndpoint-user"
  path = "/"
  tags = {
    yor_trace = "4ee4ce72-9d2e-4474-9885-8eba57f8e729"
  }
}

resource "aws_iam_access_key" "privesc19-UpdateExistingGlueDevEndpoint-user" {
  user = aws_iam_user.privesc19-UpdateExistingGlueDevEndpoint-user.name
}


resource "aws_iam_user_policy_attachment" "privesc19-UpdateExistingGlueDevEndpoint-user-attach-policy" {
  user       = aws_iam_user.privesc19-UpdateExistingGlueDevEndpoint-user.name
  policy_arn = aws_iam_policy.privesc19-UpdateExistingGlueDevEndpoint.arn
}

resource "aws_iam_role_policy_attachment" "privesc19-UpdateExistingGlueDevEndpoint-role-attach-policy" {
  role       = aws_iam_role.privesc19-UpdateExistingGlueDevEndpoint-role.name
  policy_arn = aws_iam_policy.privesc19-UpdateExistingGlueDevEndpoint.arn
}
