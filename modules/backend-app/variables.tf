# Export the VPC parameter so that it can be populated by the root module
variable "vpc" {
  description = "The main VPC."
}

# Export the 'Security Group for EC2' parameter so that it can be populated by the root module
variable "sg_for_ec2" {
  description = "The SG for EC2."
}

# Export the 'Security Group for ALB' parameter so that it can be populated by the root module
variable "sg_for_alb" {
  description = "The SG for ALB."
}

# Export the private subnets so that they can be populated by the root module
variable "private_subnets" {
  description = "The private subnets."
}

# Export the public subnets so that they can be populated by the root module
variable "public_subnets" {
  description = "The public subnets."
}

# Export the ALB's target group so that it can be populated by the root module
variable "aws_lb_target_group" {
  description = "The ALB target group."
}