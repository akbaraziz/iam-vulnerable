resource "aws_glue_dev_endpoint" "privesc-glue-devendpoint" {
  name     = "privesc-glue-devendpoint"
  role_arn = aws_iam_role.privesc-glue-devendpoint-role.arn
  tags = {
    yor_trace = "ffefe712-3786-43ed-9694-737024db662d"
  }
}

resource "aws_iam_role" "privesc-glue-devendpoint-role" {
  name               = "privesc-glue-devendpoint-role"
  assume_role_policy = data.aws_iam_policy_document.example.json
  tags = {
    yor_trace = "3bb0ea83-b864-431e-8941-659404c7b50d"
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "privesc-high-priv-glue-policy" {
  name        = "privesc-high-priv-glue-policy2"
  path        = "/"
  description = "High priv policy used by glue"
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
    yor_trace = "d9ccefe7-1bf0-4278-88bb-d44d4ebcae29"
  }
}


resource "aws_iam_role_policy_attachment" "example-AWSGlueServiceRole" {
  policy_arn = aws_iam_policy.privesc-high-priv-glue-policy.arn
  role       = aws_iam_role.privesc-glue-devendpoint-role.name
}