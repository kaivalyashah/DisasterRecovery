# DisasterRecovery/networking/variables.tf 
variable "public_subnets" {
  type = list(string)
}

variable "app_subnets" {
  type = list(string)
}

variable "db_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "region" {
  type = string
}
