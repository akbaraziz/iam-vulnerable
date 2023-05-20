resource "aws_iam_policy" "privesc21-PassExistingRoleToNewDataPipeline" {
  name        = "privesc21-PassExistingRoleToNewDataPipeline"
  path        = "/"
  description = "Allows privesc via iam:PassRole, datapipeline:CreatePipeline, datapipeline:PutPipelineDefinition, and datapipeline:ActivatePipeline"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "datapipeline:CreatePipeline",
          "datapipeline:PutPipelineDefinition",
          "datapipeline:ActivatePipeline"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = {
    yor_trace = "3364f3ef-8986-4fa9-af42-f983c7096d01"
  }
}

resource "aws_iam_role" "privesc21-PassExistingRoleToNewDataPipeline-role" {
  name = "privesc21-PassExistingRoleToNewDataPipeline-role"
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
    yor_trace = "5d6ed7da-a51d-45f6-8c8b-0c7038368066"
  }
}

resource "aws_iam_user" "privesc21-PassExistingRoleToNewDataPipeline-user" {
  name = "privesc21-PassExistingRoleToNewDataPipeline-user"
  path = "/"
  tags = {
    yor_trace = "b8b3e0f0-a500-4a0d-b567-931713265009"
  }
}

resource "aws_iam_access_key" "privesc21-PassExistingRoleToNewDataPipeline-user" {
  user = aws_iam_user.privesc21-PassExistingRoleToNewDataPipeline-user.name
}


resource "aws_iam_user_policy_attachment" "privesc21-PassExistingRoleToNewDataPipeline-user-attach-policy" {
  user       = aws_iam_user.privesc21-PassExistingRoleToNewDataPipeline-user.name
  policy_arn = aws_iam_policy.privesc21-PassExistingRoleToNewDataPipeline.arn
}

resource "aws_iam_role_policy_attachment" "privesc21-PassExistingRoleToNewDataPipeline-role-attach-policy" {
  role       = aws_iam_role.privesc21-PassExistingRoleToNewDataPipeline-role.name
  policy_arn = aws_iam_policy.privesc21-PassExistingRoleToNewDataPipeline.arn
}
