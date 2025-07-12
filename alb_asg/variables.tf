# DisasterRecovery/alb_asg/variables.tf 

variable "region" {}
variable "name_prefix" {}
variable "ami_id" {}
variable "instance_type" {}
variable "instance_sg_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "alb_sg_ids" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "internal" {
  type = bool
}
variable "tg_port" {}
variable "vpc_id" {}
variable "associate_public_ip" {
  type        = bool
  description = "Whether to associate a public IP address with the instance"
}