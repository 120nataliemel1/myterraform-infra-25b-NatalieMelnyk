resource "aws_vpc" "projectx_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.projectx_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.projectx_vpc.id
  cidr_block = var.public_subnet_cidrs[0]
  availability_zone = var.azs[0]
  map_public_ip_on_launch = true # instances/nodes launched in pub subnets automatically receive pub IPv4 add.


  tags = {
    Name = "${var.project_name}-public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.projectx_vpc.id     
  cidr_block = var.public_subnet_cidrs[1]
  availability_zone = var.azs[1]
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project_name}-public_subnet_2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id     = aws_vpc.projectx_vpc.id
  cidr_block = var.public_subnet_cidrs[2]
  availability_zone = var.azs[2]
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project_name}-public_subnet_3"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.projectx_vpc.id
  cidr_block = var.private_subnet_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "${var.project_name}-private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.projectx_vpc.id
  cidr_block = var.private_subnet_cidrs[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "${var.project_name}-private_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id     = aws_vpc.projectx_vpc.id
  cidr_block = var.private_subnet_cidrs[2]
  availability_zone = var.azs[2]

  tags = {
    Name = "${var.project_name}-private_subnet_3"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.projectx_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}