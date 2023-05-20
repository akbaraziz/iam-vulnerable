resource "aws_iam_policy" "privesc-sageMakerCreateNotebookPassRole-policy" {
  name        = "privesc-sageMakerCreateNotebookPassRole-policy"
  path        = "/"
  description = "Allows privesc via sagemakerCreateNotebook"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreateNotebookInstance",
          "sagemaker:CreatePresignedNotebookInstanceUrl",
          "sagemaker:ListNotebookInstances",
          "sagemaker:DescribeNotebookInstance",
          "sagemaker:StopNotebookInstance",
          "sagemaker:DeleteNotebookInstance",
          "iam:PassRole",
          "iam:ListRoles"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "cecce8c0-6725-4063-88c4-25c6e8d41175"
  }
}



resource "aws_iam_role" "privesc-sageMakerCreateNotebookPassRole-role" {
  name = "privesc-sageMakerCreateNotebookPassRole-role"
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
    yor_trace = "9fd11454-e114-4790-bede-5cbb58b1857b"
  }
}


resource "aws_iam_user" "privesc-sageMakerCreateNotebookPassRole-user" {
  name = "privesc-sageMakerCreateNotebookPassRole-user"
  path = "/"
  tags = {
    yor_trace = "93bba1ad-87d9-4fe1-9ab5-651c65655ce9"
  }
}

resource "aws_iam_access_key" "privesc-sageMakerCreateNotebookPassRole-user" {
  user = aws_iam_user.privesc-sageMakerCreateNotebookPassRole-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-sageMakerCreateNotebookPassRole-user-attach-policy" {
  user       = aws_iam_user.privesc-sageMakerCreateNotebookPassRole-user.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateNotebookPassRole-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sageMakerCreateNotebookPassRole-role-attach-policy" {
  role       = aws_iam_role.privesc-sageMakerCreateNotebookPassRole-role.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateNotebookPassRole-policy.arn

}

