# DisasterRecovery/output.tf 
output "vpc_east1_id" {
  value = module.networking_primary.vpc_id
}

output "public_subnets_east1" {
  value = module.networking_primary.public_subnet_ids
}

output "private_subnets_east1" {
  value = module.networking_primary.private_subnet_ids
}


output "vpc_east2_id" {
  value = module.networking_secondary.vpc_id
}

output "public_subnets_east2" {
  value = module.networking_secondary.public_subnet_ids
}

output "private_subnets_east2" {
  value = module.networking_secondary.private_subnet_ids
}
output "asg_name_web" {
  value = module.web_alb_asg_primary.asg_name
}


output "asg_name_app" {
  value = module.app_alb_asg_secondary.asg_name
}
