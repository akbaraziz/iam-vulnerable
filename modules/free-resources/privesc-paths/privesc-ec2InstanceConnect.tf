resource "aws_iam_policy" "privesc-ec2InstanceConnect-policy" {
  name        = "privesc-ec2InstanceConnect-policy"
  path        = "/"
  description = "Allows privesc via ec2-instance-connect send-public-key if the instance has a public IP, you have network access to ssh to the instance, and the instance supports instance-connect"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2-instance-connect:SendSSHPublicKey",
          "ec2-instance-connect:SendSerialConsoleSSHPublicKey",
        ]
        Resource = "*"
      },
    ]
  })
  tags = {
    yor_trace = "377f0b07-54c5-4625-be86-3896fad6b7cf"
  }
}



resource "aws_iam_role" "privesc-ec2InstanceConnect-role" {
  name = "privesc-ec2InstanceConnect-role"
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
    yor_trace = "f7dbbedd-c7be-49e0-87c8-a2765580722d"
  }
}


resource "aws_iam_user" "privesc-ec2InstanceConnect-user" {
  name = "privesc-ec2InstanceConnect-user"
  path = "/"
  tags = {
    yor_trace = "abf1742f-922e-41cb-bc25-7e3ac36c904a"
  }
}

resource "aws_iam_access_key" "privesc-ec2InstanceConnect-user" {
  user = aws_iam_user.privesc-ec2InstanceConnect-user.name
}



resource "aws_iam_user_policy_attachment" "privesc-ec2InstanceConnect-user-attach-policy" {
  user       = aws_iam_user.privesc-ec2InstanceConnect-user.name
  policy_arn = aws_iam_policy.privesc-ec2InstanceConnect-policy.arn
}


resource "aws_iam_role_policy_attachment" "privesc-ec2InstanceConnect-role-attach-policy" {
  role       = aws_iam_role.privesc-ec2InstanceConnect-role.name
  policy_arn = aws_iam_policy.privesc-ec2InstanceConnect-policy.arn

}

