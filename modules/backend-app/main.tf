# Define a list of local values for centralised reference
locals {
  region = "eu-west-3"

  vpc_cidr_block = "10.0.0.0/16"

  default_cidr_block = "0.0.0.0/0"

  ami = "ami-0302f42a44bf53a45"

  instance_type = "t2.micro"
}

# Create the launch configuration for the ASG
resource "aws_launch_configuration" "launch_config" {
  image_id        = local.ami
  instance_type   = local.instance_type
  security_groups = [aws_security_group.sg_for_ec2.id]

  user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        sudo systemctl start httpd
        sudo systemctl enable httpd
        cd /var/www/html
        echo "<html>
        <head>
        <title>A two-tier architecture for a single-page application</title>
        <style>
        body {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100vh;
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: black;
        color: white
        }
        </style>
        </head>
        <body>
        <h1>Security Charms</h1>
        </body>
        </html>" > index.html
        sudo systemctl restart httpd

    EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Create the ASG
resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.launch_config.name
  min_size             = 4
  max_size             = 10

  vpc_zone_identifier = [for subnet in var.private_subnets: subnet.id]

  target_group_arns = [var.aws_lb_target_group]
}

# Create the security group for the ALB
resource "aws_security_group" "sg_for_alb" {
  name        = "sg_for_alb"
  description = "Allow HTTP traffic from the internet."
  vpc_id      = var.vpc

  ingress {
    description = "HTTP from the world"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.default_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.default_cidr_block]
  }
}

# Create the security group for the EC2 fleet
resource "aws_security_group" "sg_for_ec2" {
  name        = "sg_for_ec2"
  description = "Allow HTTP traffic from the ALB."
  vpc_id      = var.vpc

  ingress {
    description     = "HTTP from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_for_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.default_cidr_block]
  }
}