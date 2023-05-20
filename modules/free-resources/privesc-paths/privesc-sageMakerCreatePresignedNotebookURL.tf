resource "aws_iam_policy" "privesc-sageMakerCreatePresignedNotebookURL-policy" {
  name        = "privesc-sageMakerCreatePresignedNotebookURL-policy"
  path        = "/"
  description = "Allows privesc via sagemakerCreatePresignedNotebookURL"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreatePresignedNotebookInstanceUrl",
          "sagemaker:ListNotebookInstances"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "60b33ceb-9c29-45ac-9b7a-4d1e49be5def"
  }
}



resource "aws_iam_role" "privesc-sageMakerCreatePresignedNotebookURL-role" {
  name = "privesc-sageMakerCreatePresignedNotebookURL-role"
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
    yor_trace = "2ee80665-a882-4d56-a547-1dbee69f8314"
  }
}


resource "aws_iam_user" "privesc-sageMakerCreatePresignedNotebookURL-user" {
  name = "privesc-sageMakerCreatePresignedNotebookURL-user"
  path = "/"
  tags = {
    yor_trace = "41b9c503-1dbd-4e96-9b39-d3859a8974cc"
  }
}

resource "aws_iam_access_key" "privesc-sageMakerCreatePresignedNotebookURL-user" {
  user = aws_iam_user.privesc-sageMakerCreatePresignedNotebookURL-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-sageMakerCreatePresignedNotebookURL-user-attach-policy" {
  user       = aws_iam_user.privesc-sageMakerCreatePresignedNotebookURL-user.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreatePresignedNotebookURL-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sageMakerCreatePresignedNotebookURL-role-attach-policy" {
  role       = aws_iam_role.privesc-sageMakerCreatePresignedNotebookURL-role.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreatePresignedNotebookURL-policy.arn

}

