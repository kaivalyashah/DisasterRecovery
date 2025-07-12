# DisasterRecovery/alb_asg/main.tf 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
resource "random_id" "suffix" {
  byte_length = 4
}

# Launch Template
resource "aws_launch_template" "this" {
  name_prefix   = "lt-${var.name_prefix}-${random_id.suffix.hex}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(file("${path.module}/user_data.sh"))

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip
    security_groups             = var.instance_sg_ids
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "this" {
  name                      = "asg-${var.name_prefix}-${random_id.suffix.hex}"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.this.arn]

  tag {
    key                 = "Name"
    value               = "asg-${var.name_prefix}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ALB
resource "aws_lb" "this" {
  name               = "alb-${var.name_prefix}-${random_id.suffix.hex}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.alb_sg_ids
  subnets            = var.subnet_ids

  tags = {
    Name = "alb-${var.name_prefix}"
  }
}

resource "aws_lb_target_group" "this" {
   name     = "tg-${var.name_prefix}-${random_id.suffix.hex}"
  port     = var.tg_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "tg-${var.name_prefix}"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}