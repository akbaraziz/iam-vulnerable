resource "aws_iam_policy" "privesc-AssumeRole-high-priv-policy" {
  name        = "privesc-AssumeRole-high-priv-policy"
  path        = "/"
  description = "Allows privesc via targeted sts:AssumeRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "e4a1e4eb-7520-4fa3-b848-5c1e27c1d969"
  }
}

resource "aws_iam_role" "privesc-AssumeRole-starting-role" {
  name = "privesc-AssumeRole-starting-role"
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
    yor_trace = "6f579d36-346d-4377-9a75-71919d63f133"
  }
}

resource "aws_iam_role" "privesc-AssumeRole-intermediate-role" {
  name = "privesc-AssumeRole-intermediate-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.privesc-AssumeRole-starting-role.arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "fab69c17-4160-45c8-ae9c-51ade9529d4b"
  }
}


resource "aws_iam_role" "privesc-AssumeRole-ending-role" {
  name = "privesc-AssumeRole-ending-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.privesc-AssumeRole-intermediate-role.arn
        }
      },
    ]
  })
  tags = {
    yor_trace = "1dae23bf-9138-4e52-8523-c663ff09aa9f"
  }
}



resource "aws_iam_user" "privesc-AssumeRole-start-user" {
  name = "privesc-AssumeRole-start-user"
  path = "/"
  tags = {
    yor_trace = "317016fb-6b2b-46de-9cb7-4be191ca3a95"
  }
}
resource "aws_iam_access_key" "privesc-AssumeRole-start-user" {
  user = aws_iam_user.privesc-AssumeRole-start-user.name
}
resource "aws_iam_role_policy_attachment" "privesc-AssumeRole-high-priv-policy-role-attach-policy" {
  role       = aws_iam_role.privesc-AssumeRole-ending-role.name
  policy_arn = aws_iam_policy.privesc-AssumeRole-high-priv-policy.arn

}  