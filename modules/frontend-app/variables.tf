variable "vpc" {    
  description = "The main VPC."
}

variable "sg_for_alb" {
    description = "The SG for ALB."
}

variable "public_subnets" {
    description = "The public subnets."
}