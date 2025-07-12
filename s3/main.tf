# DisasterRecovery/s3/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.east1, aws.east2]
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  provider       = aws.east1
  bucket         = "my-disaster-recovery-bucket-${random_id.suffix.hex}"
  force_destroy  = true

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_iam_role" "role_east1" {
  provider = aws.east1
  name     = "my-disaster-recovery-bucket-s3-policy-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "role_east2" {
  provider = aws.east2
  name     = "my-disaster-recovery-bucket-s3-policy-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  provider = aws.east1
  name     = "${var.bucket_name}-s3-policy-${random_id.suffix.hex}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
      Resource = [
        "arn:aws:s3:::${aws_s3_bucket.this.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_east1" {
  provider   = aws.east1
  role       = aws_iam_role.role_east1.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_east2" {
  provider   = aws.east2
  role       = aws_iam_role.role_east2.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
