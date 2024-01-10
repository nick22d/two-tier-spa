# Return the VPC so that it can be referenced by the root module
output "vpc" {
  description = "The main VPC."
  value       = aws_vpc.main.id
}

# Return the public subnets so that they can be referenced by the root module
output "public_subnets" {
  description = "The VPC's public subnets."
  value       = aws_subnet.public_subnets
}

# Return the private subnets so that they can be referenced by the root module
output "private_subnets" {
  description = "The VPC's private subnets."
  value       = aws_subnet.private_subnets
}