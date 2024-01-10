# Define a list of local values for centralised reference
locals {
  region = "eu-west-3"

  vpc_cidr_block = "10.0.0.0/16"

  default_cidr_block = "0.0.0.0/0"

  ami = "ami-0302f42a44bf53a45"

  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  azs = ["eu-west-3a", "eu-west-3b"]

}

# Configure the AWS Provider
provider "aws" {
  region = local.region
}

# Create the main VPC
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block
}

# Create the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Create the EIP that will be associated with the NAT gateway
resource "aws_eip" "ngw" {
  domain = "vpc"

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Crete the NAT gateway so that the private instances can communicate with the ALB
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public_subnets[0].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Create the route table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Route for internal communication
  route {
    cidr_block = local.vpc_cidr_block
    gateway_id = "local"
  }
  # Default route to the IGW
  route {
    cidr_block = local.default_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Create the route table for the private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # Route for internal communication
  route {
    cidr_block = local.vpc_cidr_block
    gateway_id = "local"
  }

  # Default route to the NAT GW
  route {
    cidr_block     = local.default_cidr_block
    nat_gateway_id = aws_nat_gateway.ngw.id
  }


  tags = {
    Name = "PrivateRouteTable"
  }
}

# Create the association between the public route table and the public subnets
resource "aws_route_table_association" "public" {
  count          = length(local.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# Create the association between the private route table and the private subnets
resource "aws_route_table_association" "private" {
  count          = length(local.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# Create the public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(local.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.azs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }

}

# Create the private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(local.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.azs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}