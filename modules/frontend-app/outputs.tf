# Output the DNS name of the ALB
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_target_group" {
  value = aws_lb_target_group.lb_tg.arn
}