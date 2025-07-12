# DisasterRecovery/s3/output.tf
output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "east1_role_name" {
  value = aws_iam_role.role_east1.name
}

output "east2_role_name" {
  value = aws_iam_role.role_east2.name
}