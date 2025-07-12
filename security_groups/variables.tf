# security_groups/variables.tf

variable "vpc_id" {
  description = "VPC ID to attach the security groups"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
}

variable "region" {
  description = "Region name for naming conventions"
  type        = string
}
