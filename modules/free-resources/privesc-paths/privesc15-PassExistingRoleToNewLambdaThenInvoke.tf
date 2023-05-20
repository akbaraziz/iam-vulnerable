resource "aws_iam_policy" "privesc15-PassExistingRoleToNewLambdaThenInvoke" {
  name        = "privesc15-PassExistingRoleToNewLambdaThenInvoke"
  path        = "/"
  description = "Allows privesc via lambda:createfunction, invokefunction and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole",
          "lambda:CreateFunction",
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "dcadab22-2f40-4b97-af5c-427a02394a4d"
  }
}

resource "aws_iam_role" "privesc15-PassExistingRoleToNewLambdaThenInvoke-role" {
  name = "privesc15-PassExistingRoleToNewLambdaThenInvoke-role"
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
    yor_trace = "a1d63aa9-cda6-411f-be34-7ba021e3a264"
  }
}

resource "aws_iam_user" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user" {
  name = "privesc15-PassExistingRoleToNewLambdaThenInvoke-user"
  path = "/"
  tags = {
    yor_trace = "e69c7391-10b4-4823-8f03-99167a65a059"
  }
}

resource "aws_iam_access_key" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user" {
  user = aws_iam_user.privesc15-PassExistingRoleToNewLambdaThenInvoke-user.name
}


resource "aws_iam_user_policy_attachment" "privesc15-PassExistingRoleToNewLambdaThenInvoke-user-attach-policy" {
  user       = aws_iam_user.privesc15-PassExistingRoleToNewLambdaThenInvoke-user.name
  policy_arn = aws_iam_policy.privesc15-PassExistingRoleToNewLambdaThenInvoke.arn
}

resource "aws_iam_role_policy_attachment" "privesc15-PassExistingRoleToNewLambdaThenInvoke-role-attach-policy" {
  role       = aws_iam_role.privesc15-PassExistingRoleToNewLambdaThenInvoke-role.name
  policy_arn = aws_iam_policy.privesc15-PassExistingRoleToNewLambdaThenInvoke.arn
}
