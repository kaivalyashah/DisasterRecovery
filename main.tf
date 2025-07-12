# DisasterRecovery/main.tf 
provider "aws" {
  alias  = "east1"
  region = var.region_east1
}

provider "aws" {
  alias  = "east2"
  region = var.region_east2
}

# VPC
module "networking_primary" {
  source         = "./networking"
  region         = var.region_east1
  vpc_cidr       = var.vpc_cidr_east1
  public_subnets = var.public_subnets_east1
  app_subnets    = var.app_subnets_east1
  db_subnets     = var.db_subnets_east1
  azs            = var.azs_east1
}

module "networking_secondary" {
  source         = "./networking"
  region         = var.region_east2
  vpc_cidr       = var.vpc_cidr_east2
  public_subnets = var.public_subnets_east2
  app_subnets    = var.app_subnets_east2
  db_subnets     = var.db_subnets_east2
  azs            = var.azs_east2
}


# Security Groups 

module "security_groups_primary" {
  source   = "./security_groups"
  vpc_id   = module.networking_primary.vpc_id
  vpc_cidr = var.vpc_cidr_east1
  region   = var.region_east1    
  providers = {
    aws.this = aws.east1
  }
  depends_on = [module.networking_primary]   
}


module "security_groups_secondary" {
  source   = "./security_groups"
  vpc_id   = module.networking_secondary.vpc_id
  vpc_cidr = var.vpc_cidr_east2
  region   = var.region_east2  
  providers = {
    aws.this = aws.east2
  }
  depends_on = [module.networking_secondary]     
}


# # ALB and ASG
# module "web_alb_asg_primary" {
#   source              = "./alb_asg"
#   providers           = { aws = aws.east1 }
#   region              = var.region_east1
#   associate_public_ip = true
#   name_prefix         = "web-e1"
#   ami_id              = var.amis["us-east-1"]
#   instance_type       = var.instance_type
#   instance_sg_ids     = [module.security_groups_primary.web_sg_id]
#   private_subnet_ids  = module.networking_primary.private_subnet_ids
#   alb_sg_ids          = [module.security_groups_primary.alb_external_sg_id]
#   subnet_ids          = module.networking_primary.app_subnet_ids
#   internal            = false
#   tg_port             = 80
#   vpc_id              = module.networking_primary.vpc_id
#   depends_on          = [
#     module.security_groups_primary,
#     module.networking_primary
#   ]
# }


# module "app_alb_asg_secondary" {
#   source              = "./alb_asg"
#   providers           = { aws = aws.east2 }
#   region              = var.region_east2
#   name_prefix         = "app-e2"
#   associate_public_ip = false
#   ami_id              = var.amis["us-east-2"]
#   instance_type       = var.instance_type
#   instance_sg_ids     = [module.security_groups_secondary.app_sg_id]
#   private_subnet_ids  = module.networking_secondary.private_subnet_ids
#   alb_sg_ids          = [module.security_groups_secondary.alb_internal_sg_id]
#   subnet_ids          = module.networking_secondary.app_subnet_ids
#   internal            = true
#   tg_port             = 8080
#   vpc_id              = module.networking_secondary.vpc_id
#   depends_on          = [
#     module.security_groups_secondary,
#     module.networking_secondary
#   ]
# }

# ALB and ASG for PRIMARY region (us-east-1)
module "web_alb_asg_primary" {
  source              = "./alb_asg"
  providers           = { aws = aws.east1 }
  region              = var.region_east1
  associate_public_ip = true
  name_prefix         = "web-e1"
  ami_id              = var.amis["us-east-1"]
  instance_type       = var.instance_type
  instance_sg_ids     = [module.security_groups_primary.web_sg_id]
  private_subnet_ids  = module.networking_primary.public_subnet_ids
  alb_sg_ids          = [module.security_groups_primary.alb_external_sg_id]
  subnet_ids          = module.networking_primary.public_subnet_ids
  internal            = false
  tg_port             = 80
  vpc_id              = module.networking_primary.vpc_id
  depends_on          = [
    module.security_groups_primary,
    module.networking_primary
  ]
}

module "app_alb_asg_primary" {
  source              = "./alb_asg"
  providers           = { aws = aws.east1 }
  region              = var.region_east1
  name_prefix         = "app-e1"
  associate_public_ip = false
  ami_id              = var.amis["us-east-1"]
  instance_type       = var.instance_type
  instance_sg_ids     = [module.security_groups_primary.app_sg_id]
  private_subnet_ids  = module.networking_primary.private_subnet_ids
  alb_sg_ids          = [module.security_groups_primary.alb_internal_sg_id]
  subnet_ids          = module.networking_primary.app_subnet_ids
  internal            = true
  tg_port             = 8080
  vpc_id              = module.networking_primary.vpc_id
  depends_on          = [
    module.security_groups_primary,
    module.networking_primary
  ]
}

# ALB and ASG for SECONDARY region (us-east-2)
module "web_alb_asg_secondary" {
  source              = "./alb_asg"
  providers           = { aws = aws.east2 }
  region              = var.region_east2
  name_prefix         = "web-e2"
  associate_public_ip = true
  ami_id              = var.amis["us-east-2"]
  instance_type       = var.instance_type
  instance_sg_ids     = [module.security_groups_secondary.web_sg_id]
  private_subnet_ids  = module.networking_secondary.public_subnet_ids
  alb_sg_ids          = [module.security_groups_secondary.alb_external_sg_id]
  subnet_ids          = module.networking_secondary.public_subnet_ids
  internal            = false
  tg_port             = 80
  vpc_id              = module.networking_secondary.vpc_id
  depends_on          = [
    module.security_groups_secondary,
    module.networking_secondary
  ]
}

module "app_alb_asg_secondary" {
  source              = "./alb_asg"
  providers           = { aws = aws.east2 }
  region              = var.region_east2
  name_prefix         = "app-e2"
  associate_public_ip = false
  ami_id              = var.amis["us-east-2"]
  instance_type       = var.instance_type
  instance_sg_ids     = [module.security_groups_secondary.app_sg_id]
  private_subnet_ids  = module.networking_secondary.private_subnet_ids
  alb_sg_ids          = [module.security_groups_secondary.alb_internal_sg_id]
  subnet_ids          = module.networking_secondary.app_subnet_ids
  internal            = true
  tg_port             = 8080
  vpc_id              = module.networking_secondary.vpc_id
  depends_on          = [
    module.security_groups_secondary,
    module.networking_secondary
  ]
}

# S3
/*module "s3" {
  source        = "./s3"
  bucket_name   = "my-disaster-recovery-bucket"
  region_east1  = var.region_east1
  region_east2  = var.region_east2

  providers = {
    aws.east1 = aws.east1
    aws.east2 = aws.east2
  }
}
*/

#RDS
# module "rds" {
#   source                = "./rds"
#   db_name               = "myappdb"
#   username              = "admin"
#   password              = "MySecureP@ss123"
#   instance_class        = "db.t3.micro"
#   vpc_security_group_ids = [module.security_groups_primary.db_sg_id]
#   subnet_ids            = module.networking_primary.private_subnet_ids
#   region_east1          = var.region_east1
#   region_east2          = var.region_east2

#   providers = {
#     aws.east1 = aws.east1
#     aws.east2 = aws.east2
#   }
# }
