resource "aws_iam_policy" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo" {
  name        = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo"
  path        = "/"
  description = "Allows privesc via lambda:createfunction, CreateEventSourceMapping and iam:passrole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:CreateFunction",
          "iam:PassRole",
          "lambda:CreateEventSourceMapping"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "67b7bae9-19f4-4e4c-a6a9-4d6ba74add94"
  }
}

resource "aws_iam_role" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role" {
  name = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role"
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
    yor_trace = "efe4a139-4c8d-4d3e-b449-535f120468b2"
  }
}

resource "aws_iam_user" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user" {
  name = "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user"
  path = "/"
  tags = {
    yor_trace = "74b621c4-718c-451b-b8e7-3da3062c5dea"
  }
}

resource "aws_iam_access_key" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user" {
  user = aws_iam_user.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user.name
}


resource "aws_iam_user_policy_attachment" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user-attach-policy" {
  user       = aws_iam_user.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-user.name
  policy_arn = aws_iam_policy.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo.arn
}

resource "aws_iam_role_policy_attachment" "privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role-attach-policy" {
  role       = aws_iam_role.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo-role.name
  policy_arn = aws_iam_policy.privesc16-PassRoleToNewLambdaThenTriggerWithNewDynamo.arn
}