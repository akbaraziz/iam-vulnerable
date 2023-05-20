resource "aws_sagemaker_notebook_instance" "privesc-sagemakerNotebook" {
  name          = "privesc-sagemakerNotebook"
  role_arn      = aws_iam_role.privesc-sagemaker-role.arn
  instance_type = "ml.t2.medium"

  tags = {
    Name      = "foo"
    yor_trace = "f6177c5c-8a46-4390-aec8-f7a67d730b7b"
  }
}


resource "aws_iam_role" "privesc-sagemaker-role" {
  name               = "privesc-sagemaker-role"
  assume_role_policy = data.aws_iam_policy_document.example.json
  tags = {
    yor_trace = "b31bf341-e5be-437e-9644-067d0d5ba525"
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "privesc-high-priv-sagemaker-policy" {
  name        = "privesc-high-priv-sagemaker-policy2"
  path        = "/"
  description = "High priv policy used by sagemaker"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "c01a590f-f122-49d2-9f81-b7f42a1f95f3"
  }
}


resource "aws_iam_role_policy_attachment" "example-AWSSagemakerServiceRole" {
  policy_arn = aws_iam_policy.privesc-high-priv-sagemaker-policy.arn
  role       = aws_iam_role.privesc-sagemaker-role.name
}