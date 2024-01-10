# Return the DNS name of the ALB
output "alb_dns_name" {
  description = "The DNS name of the ALB is displayed so that the SPA can be accessed."
  value       = module.frontend-app.alb_dns_name
}