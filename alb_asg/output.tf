# DisasterRecovery/alb_asg/output.tf 

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "asg_name" {
  value = aws_autoscaling_group.this.name
}