
# This is a role that does not have any policies attached, but it demonstrates a bad practice. You should never trust the root of an account. That means that anyone who can assume any role can automatically assume this role. You shoul always limit who can assume the role using the principal of least privilege. 

resource "aws_iam_role" "privesc-permissive-role-trust" {
  name = "privesc-permissive-role-trust"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = var.aws_root_user
        }
      },
    ]
  })
  tags = {
    yor_trace = "bbc07b73-0eab-49f4-89af-f29275a38621"
  }
}

