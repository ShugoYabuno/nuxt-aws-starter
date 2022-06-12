resource "aws_vpc" "vpc" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true

  tags = {
    Name = var.project_name
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true

  tags = {
    Name = var.project_name
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.project_name
  }
}

resource "aws_security_group" "security_group" {
  name   = var.project_name
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}
