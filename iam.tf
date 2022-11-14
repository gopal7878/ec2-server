resource "aws_iam_role" "ec2" {
  name               = "role-ec2"
  description        = "Used by EC2"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF

  tags = {
    "Name"             = "role-ec2"
    "Application Role" = "Configuration"
    "Stack Policy"     = "Protected"
  }
}



resource "aws_s3_bucket" "buddy" {
  bucket = "buddytasks21"
}

resource "aws_iam_policy" "bucket_policy" {
  name        = var.default_state_bucket 
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket_policy" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}

resource "aws_iam_instance_profile" "ec2" {
  name = aws_iam_role.ec2.name
  role = aws_iam_role.ec2.name
}
