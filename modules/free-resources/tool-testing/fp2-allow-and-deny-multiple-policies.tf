resource "aws_iam_policy" "fp2-allow-all" {
  name        = "fp2-allow-all"
  path        = "/"
  description = "Allows everything"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "fdbc18da-d878-4506-b4ba-9deb6f279eb1"
  }
}

resource "aws_iam_policy" "deny-all" {
  name        = "deny-all"
  path        = "/"
  description = "Denies everything"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny",
        Action   = "*",
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "b151f30f-58f5-4ac3-9eb8-dfbd27b42e82"
  }
}




resource "aws_iam_role" "fp2-allow-and-deny-multiple-policies-role" {
  name = "fp2-allow-and-deny-multiple-policies-role"
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
    yor_trace = "b1127f7f-803e-4c93-a293-81253049f82d"
  }
}

resource "aws_iam_user" "fp2-allow-and-deny-multiple-policies-user" {
  name = "fp2-allow-and-deny-multiple-policies-user"
  path = "/"
  tags = {
    yor_trace = "1e43db15-4438-40af-9858-1e0bf4672eba"
  }
}

resource "aws_iam_access_key" "fp2-allow-and-deny-multiple-policies-user" {
  user = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
}



resource "aws_iam_user_policy_attachment" "fp2-allow-and-deny-attach-allow-to-user" {
  user       = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
  policy_arn = aws_iam_policy.fp2-allow-all.arn
}

resource "aws_iam_user_policy_attachment" "fp2-allow-and-deny-attach-deny-to-user" {
  user       = aws_iam_user.fp2-allow-and-deny-multiple-policies-user.name
  policy_arn = aws_iam_policy.deny-all.arn
}

resource "aws_iam_role_policy_attachment" "fp2-allow-and-deny-attach-allow-to-role" {
  role       = aws_iam_role.fp2-allow-and-deny-multiple-policies-role.name
  policy_arn = aws_iam_policy.fp2-allow-all.arn

}

resource "aws_iam_role_policy_attachment" "fp2-allow-and-deny-attach-deny-to-roler" {
  role       = aws_iam_role.fp2-allow-and-deny-multiple-policies-role.name
  policy_arn = aws_iam_policy.deny-all.arn

}
