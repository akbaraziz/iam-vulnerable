# Tools that assess privesc risk from a policy perspective will miss roles that have privesc potential as a result of two or more policies. This partial policy helps you figure out which tools will alert on this. 

resource "aws_iam_policy" "fn1-privesc3-partial" {
  name        = "fn1-privesc3-partial"
  path        = "/"
  description = "Allows ec2:RunInstances, but missing iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:RunInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "5e8022a6-c0ba-491f-86ae-503814019616"
  }
}

resource "aws_iam_policy" "fn1-passrole-star" {
  name        = "fn1-passrole-star"
  path        = "/"
  description = "By itself iam:passrole does not allow privesc, but combined certain sensitive permissions it can"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "76d69066-c0c0-4e91-bf2c-dee2c082936e"
  }
}


resource "aws_iam_role" "fn1-privesc3-partial-role" {
  name = "fn1-privesc3-partial-role"
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
    yor_trace = "f71ee499-482c-4ecc-9818-eae641e52edf"
  }
}

resource "aws_iam_user" "fn1-privesc3-partial-user" {
  name = "fn1-privesc3-partial-user"
  path = "/"
  tags = {
    yor_trace = "14f19c45-9cd6-462f-8862-91f32828af36"
  }
}

resource "aws_iam_access_key" "fn1-privesc3-partial-user" {
  user = aws_iam_user.fn1-privesc3-partial-user.name
}


resource "aws_iam_user_policy_attachment" "fn1-privesc3-partial-user-attach-policy" {
  user       = aws_iam_user.fn1-privesc3-partial-user.name
  policy_arn = aws_iam_policy.fn1-privesc3-partial.arn
}

resource "aws_iam_user_policy_attachment" "privesc3-passrole-user-attach-policy" {
  user       = aws_iam_user.fn1-privesc3-partial-user.name
  policy_arn = aws_iam_policy.fn1-passrole-star.arn

}


resource "aws_iam_role_policy_attachment" "fn1-privesc3-partial-role-attach-policy" {
  role       = aws_iam_role.fn1-privesc3-partial-role.name
  policy_arn = aws_iam_policy.fn1-privesc3-partial.arn

}

resource "aws_iam_role_policy_attachment" "privesc3-passrole-role-attach-policy" {
  role       = aws_iam_role.fn1-privesc3-partial-role.name
  policy_arn = aws_iam_policy.fn1-passrole-star.arn

}








