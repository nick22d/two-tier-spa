variable "vpc" {    
  description = "The main VPC."
}

variable "sg_for_ec2" {
    description = "The SG for EC2."
}

variable "sg_for_alb" {
    description = "The SG for ALB."
}

variable "private_subnets" {
    description = "The private subnets."
}

variable "public_subnets" {
    description = "The public subnets."
}

variable "aws_lb_target_group" {
    description = "The ALB target group."
}