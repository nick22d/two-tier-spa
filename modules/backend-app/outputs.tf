# Return the Security Group of the ALB
output "sg_for_alb" {
  description = "The Security Group used by the ALB."
  value       = aws_security_group.sg_for_alb.id
}

# Return the Security Group of the backend EC2 instances
output "sg_for_ec2" {
  description = "The Security Group used by the backend EC2 fleet."
  value       = aws_security_group.sg_for_ec2.id
}