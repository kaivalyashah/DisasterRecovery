# DisasterRecovery/networking/output.tf 
output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "app_subnet_ids" {
  value = aws_subnet.app_subnets[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db_subnets[*].id
}

output "private_subnet_ids" {
  value = concat(
    aws_subnet.app_subnets[*].id,
    aws_subnet.db_subnets[*].id
  )
}

output "vpc_id" {
  value = aws_vpc.main.id
}


# output "web_sg_id" {
#   value = aws_security_group.web_sg.id
# }

# output "app_sg_id" {
#   value = aws_security_group.app_sg.id
# }

# output "alb_external_sg_id" {
#   value = aws_security_group.alb_external_sg.id
# }

# output "alb_internal_sg_id" {
#   value = aws_security_group.alb_internal_sg.id
# }
