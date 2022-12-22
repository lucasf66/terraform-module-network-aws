resource "aws_vpc" "vpc_remote_state" {
  cidr_block = var.cidr_vpc
  tags = {
    Name = "vpc-${var.environment}"
  }
}

resource "aws_subnet" "subnet_remote_state" {
  vpc_id     = aws_vpc.vpc_remote_state.id
  cidr_block = var.cidr_subnet
  tags = {
    Name = "subnet-${var.environment}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_remote_state.id
  tags = {
    Name = "gw-${var.environment}"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc_remote_state.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route-${var.environment}"
  }
}

resource "aws_route_table_association" "rt_associate" {
  subnet_id      = aws_subnet.subnet_remote_state.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "sg_remote_state" {
  name        = "Sg-${var.environment}"
  description = "Allow inbound/outbound"
  vpc_id      = aws_vpc.vpc_remote_state.id

  ingress {
    description = "Allow ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}