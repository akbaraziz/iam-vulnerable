# Does the tool evaluate deny's first before allows like AWS does? Many tools ignore or incorrectly handle DENY actions

resource "aws_iam_policy" "fp3-deny-iam" {
  name        = "fp3-deny-iam"
  path        = "/"
  description = ""

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "iam:*"
        Resource = "*"
      }
    ]
  })
  tags = {
    yor_trace = "09abd501-8e6a-4c6e-8131-9231d9290f5e"
  }
}

resource "aws_iam_role" "fp3-deny-iam-role" {
  name = "fp3-deny-iam-role"
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
    yor_trace = "1352c25f-6183-469e-b787-f3a81b8b9e66"
  }
}

resource "aws_iam_user" "fp3-deny-iam-user" {
  name = "fp3-deny-iam-user"
  path = "/"
  tags = {
    yor_trace = "a2cc7dfe-ce31-4814-aa96-c117134efce2"
  }
}

resource "aws_iam_access_key" "fp3-deny-iam-user" {
  user = aws_iam_user.fp3-deny-iam-user.name
}

resource "aws_iam_user_policy_attachment" "fp3-deny-iam-user-attach-policy" {
  user       = aws_iam_user.fp3-deny-iam-user.name
  policy_arn = aws_iam_policy.fp3-deny-iam.arn
}


resource "aws_iam_role_policy_attachment" "fp3-deny-iam-role-attach-policy" {
  role       = aws_iam_role.fp3-deny-iam-role.name
  policy_arn = aws_iam_policy.fp3-deny-iam.arn

}
