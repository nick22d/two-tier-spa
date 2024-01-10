# Return the DNS name of the ALB
output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = aws_lb.alb.dns_name
}

# Return the target group of the ALB
output "alb_target_group" {
  description = "The target group to which the ALB forwards HTTP traffic."
  value       = aws_lb_target_group.lb_tg.arn
}