resource "aws_iam_policy" "privesc-sageMakerCreateTrainingJobPassRole-policy" {
  name        = "privesc-sageMakerCreateTrainingJobPassRole-policy"
  path        = "/"
  description = "Allows privesc via sagemakerCreateTraining"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sagemaker:CreateTrainingJob",
          "iam:PassRole"
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "9f4daee3-d53c-46b1-a835-08ea9cf7a8e3"
  }
}



resource "aws_iam_role" "privesc-sageMakerCreateTrainingJobPassRole-role" {
  name = "privesc-sageMakerCreateTrainingJobPassRole-role"
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
    yor_trace = "4ce9e8e6-c223-48fe-8ff6-dfa8b22a5585"
  }
}


resource "aws_iam_user" "privesc-sageMakerCreateTrainingJobPassRole-user" {
  name = "privesc-sageMakerCreateTrainingJobPassRole-user"
  path = "/"
  tags = {
    yor_trace = "4fb9d4cb-73b5-4330-81c3-aed3ee9d3bf1"
  }
}

resource "aws_iam_access_key" "privesc-sageMakerCreateTrainingJobPassRole-user" {
  user = aws_iam_user.privesc-sageMakerCreateTrainingJobPassRole-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-sageMakerCreateTrainingJobPassRole-user-attach-policy" {
  user       = aws_iam_user.privesc-sageMakerCreateTrainingJobPassRole-user.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateTrainingJobPassRole-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-sageMakerCreateTrainingJobPassRole-role-attach-policy" {
  role       = aws_iam_role.privesc-sageMakerCreateTrainingJobPassRole-role.name
  policy_arn = aws_iam_policy.privesc-sageMakerCreateTrainingJobPassRole-policy.arn

}

