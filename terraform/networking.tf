resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true

  tags = {
    Name = var.project_name
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "${var.project_name}-main"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.2.0.0/16"
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc_ipv4_cidr_block_association.secondary.vpc_id
  cidr_block        = "172.2.0.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.project_name}-secondary"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.project_name
  }
}

resource "aws_security_group" "security_group" {
  name   = var.project_name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_route_table_association" "route_table_association_main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "route_table_association_secondary" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.route_table.id
}
