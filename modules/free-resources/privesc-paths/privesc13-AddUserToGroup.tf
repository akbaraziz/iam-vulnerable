resource "aws_iam_policy" "privesc13-AddUserToGroup" {
  name        = "privesc13-AddUserToGroup"
  path        = "/"
  description = "Allows privesc via iam:AddUserToGroup"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:AddUserToGroup"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "1a5e36ca-5404-4e9f-bfb5-8b24ae5ad6b4"
  }
}

resource "aws_iam_role" "privesc13-AddUserToGroup-role" {
  name = "privesc13-AddUserToGroup-role"
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
    yor_trace = "b923359b-1c34-4152-ad5e-a2ffc3750141"
  }
}

resource "aws_iam_user" "privesc13-AddUserToGroup-user" {
  name = "privesc13-AddUserToGroup-user"
  path = "/"
  tags = {
    yor_trace = "76dc4a9d-1e7b-4c19-b53d-9b5310b24784"
  }
}

resource "aws_iam_access_key" "privesc13-AddUserToGroup-user" {
  user = aws_iam_user.privesc13-AddUserToGroup-user.name
}


resource "aws_iam_user_policy_attachment" "privesc13-AddUserToGroup-user-attach-policy" {
  user       = aws_iam_user.privesc13-AddUserToGroup-user.name
  policy_arn = aws_iam_policy.privesc13-AddUserToGroup.arn
}

resource "aws_iam_role_policy_attachment" "privesc13-AddUserToGroup-role-attach-policy" {
  role       = aws_iam_role.privesc13-AddUserToGroup-role.name
  policy_arn = aws_iam_policy.privesc13-AddUserToGroup.arn
}


