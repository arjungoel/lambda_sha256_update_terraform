# lambda execution role
resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda-execution-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
   }]
}
EOF
}

resource "aws_iam_policy" "service_role_access_policy" {
  name        = "lambda-access-policy"
  path        = "/"
  description = "IAM policy for providing lambda access"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.lambda_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.lambda_bucket.bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_access_policy" {
  name       = "lambda-access-policy"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = aws_iam_policy.service_role_access_policy.arn
}