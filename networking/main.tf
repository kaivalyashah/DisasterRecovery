# DisasterRecovery/networking/main.tf 
provider "aws" {
  alias  = "region"
  region = var.region
}

# VPC
resource "aws_vpc" "main" {
  provider             = aws.region
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${var.region}"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  provider                = aws.region
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}-${var.region}"
  }
}

# App Subnets
resource "aws_subnet" "app_subnets" {
  provider          = aws.region
  count             = length(var.app_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "app-subnet-${count.index}-${var.region}"
  }
}

# DB Subnets
resource "aws_subnet" "db_subnets" {
  provider          = aws.region
  count             = length(var.db_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "db-subnet-${count.index}-${var.region}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  provider = aws.region
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "igw-${var.region}"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  provider = aws.region
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt-${var.region}"
  }
}

# Associate Public Subnets
resource "aws_route_table_association" "public" {
  provider = aws.region
  count    = length(aws_subnet.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  provider = aws.region
  domain   = "vpc"
  tags = {
    Name = "nat-eip-${var.region}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  provider      = aws.region
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "nat-gateway-${var.region}"
  }
}

# Private Route Tables for App Subnets
resource "aws_route_table" "private_app" {
  provider = aws.region
  count    = length(aws_subnet.app_subnets)
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-app-rt-${count.index}-${var.region}"
  }
}

# Associate App Subnets to their Route Tables
resource "aws_route_table_association" "private_app" {
  provider = aws.region
  count    = length(aws_subnet.app_subnets)

  subnet_id      = aws_subnet.app_subnets[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}

# Single Route Table for DB Subnets (no outbound)
resource "aws_route_table" "private_db" {
  provider = aws.region
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "private-db-rt-${var.region}"
  }
}

# Associate All DB Subnets to DB Route Table
resource "aws_route_table_association" "private_db" {
  provider = aws.region
  count    = length(aws_subnet.db_subnets)

  subnet_id      = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.private_db.id
}
