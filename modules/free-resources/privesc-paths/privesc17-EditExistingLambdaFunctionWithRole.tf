resource "aws_iam_policy" "privesc17-EditExistingLambdaFunctionWithRole" {
  name        = "privesc17-EditExistingLambdaFunctionWithRole"
  path        = "/"
  description = "Allows privesc via lambda:UpdateFunctionCode"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "ec819e12-8e49-4c46-abf2-c28f30716bec"
  }
}

resource "aws_iam_role" "privesc17-EditExistingLambdaFunctionWithRole-role" {
  name = "privesc17-EditExistingLambdaFunctionWithRole-role"
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
    yor_trace = "d7a1ecb7-036b-4c38-b297-7ab6294adfa1"
  }
}

resource "aws_iam_user" "privesc17-EditExistingLambdaFunctionWithRole-user" {
  name = "privesc17-EditExistingLambdaFunctionWithRole-user"
  path = "/"
  tags = {
    yor_trace = "d16b3dd4-e40e-4cc2-8444-a680d7d1449a"
  }
}

resource "aws_iam_access_key" "privesc17-EditExistingLambdaFunctionWithRole-user" {
  user = aws_iam_user.privesc17-EditExistingLambdaFunctionWithRole-user.name
}


resource "aws_iam_user_policy_attachment" "privesc17-EditExistingLambdaFunctionWithRole-user-attach-policy" {
  user       = aws_iam_user.privesc17-EditExistingLambdaFunctionWithRole-user.name
  policy_arn = aws_iam_policy.privesc17-EditExistingLambdaFunctionWithRole.arn
}

resource "aws_iam_role_policy_attachment" "privesc17-EditExistingLambdaFunctionWithRole-role-attach-policy" {
  role       = aws_iam_role.privesc17-EditExistingLambdaFunctionWithRole-role.name
  policy_arn = aws_iam_policy.privesc17-EditExistingLambdaFunctionWithRole.arn
}
