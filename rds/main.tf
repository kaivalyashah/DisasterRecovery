# Subnet group in us-east-1
# resource "aws_db_subnet_group" "this" {
#   provider    = aws.east1
#   name        = "rds-subnet-group"
#   subnet_ids  = var.subnet_ids
#   description = "RDS subnet group"

#   tags = {
#     Name = "rds-subnet-group"
#   }
# }

# Primary RDS instance in us-east-1
# resource "aws_db_instance" "primary" {
#   provider            = aws.east1
#   identifier          = "${var.db_name}-primary"
#   engine              = "mysql"
#   instance_class      = var.instance_class
#   allocated_storage   = 20
#   name                = var.db_name
#   username            = var.username
#   password            = var.password
#   db_subnet_group_name = aws_db_subnet_group.this.name
#   vpc_security_group_ids = var.vpc_security_group_ids
#   skip_final_snapshot = true
#   multi_az            = false

#   tags = {
#     Name = "${var.db_name}-primary"
#   }
# }

# # Read Replica in us-east-2
# resource "aws_db_instance" "replica" {
#   provider             = aws.east2
#   identifier           = "${var.db_name}-replica"
#   engine               = "mysql"
#   instance_class       = var.instance_class
#   replicate_source_db  = aws_db_instance.primary.arn
#   publicly_accessible  = false
#   skip_final_snapshot  = true

#   tags = {
#     Name = "${var.db_name}-replica"
#   }
# }
