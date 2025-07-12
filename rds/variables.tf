variable "db_name" {
  type        = string
  description = "Database name"
}

variable "username" {
  type        = string
  description = "Master username"
}

variable "password" {
  type        = string
  description = "Master password"
  sensitive   = true
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "RDS instance type"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security groups for RDS"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for RDS subnet group (us-east-1)"
}

variable "region_east1" {
  type = string
}

variable "region_east2" {
  type = string
}
