# DisasterRecovery/s3/variables.tf
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "region_east1" {
  type = string
}

variable "region_east2" {
  type = string
}
