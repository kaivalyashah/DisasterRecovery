# DisasterRecovery/terraform.tfvars 

# Regions
region_east1 = "us-east-1"
region_east2 = "us-east-2"

# VPC CIDRs
vpc_cidr_east1 = "10.0.0.0/16"
vpc_cidr_east2 = "10.1.0.0/16"


# Public Subnets
public_subnets_east1 = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets_east2 = ["10.1.1.0/24", "10.1.2.0/24"]

# App Subnets
app_subnets_east1 = ["10.0.3.0/24", "10.0.4.0/24"]
app_subnets_east2 = ["10.1.3.0/24", "10.1.4.0/24"]

# DB Subnets
db_subnets_east1 = ["10.0.5.0/24", "10.0.6.0/24"]
db_subnets_east2 = ["10.1.5.0/24", "10.1.6.0/24"]

# Availability Zones
azs_east1 = ["us-east-1a", "us-east-1b"]
azs_east2 = ["us-east-2a", "us-east-2b"]

# AMIs and Instance Type
amis = {
  "us-east-1" = "ami-05ffe3c48a9991133"
  "us-east-2" = "ami-0c803b171269e2d72"
}
instance_type = "t3.micro"