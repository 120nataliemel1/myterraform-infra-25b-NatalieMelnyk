resource "aws_vpc" "projectx_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
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
  vpc_id                  = aws_vpc.projectx_vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true # instances/nodes launched in pub subnets automatically receive pub IPv4 addresses


  tags = {
    Name = "${var.project_name}-public_subnet_1"
    # Human-readable subnet name for console clarity & ops visibility

    Environment = var.environment
    # Env identifier (dev/staging/prod) used for cost tracking, safety & shared infra clarity

    "kubernetes.io/cluster/${var.project_name}" = "shared"
    # Allows the EKS cluster to use this subnet without owning or deleting it (required for shared VPCs)

    "kubernetes.io/role/elb" = "1"
    # Marks this subnet as eligible for public-facing AWS load balancers created by Kubernetes (ALB/NLB)

  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.projectx_vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project_name}-public_subnet_2"

    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.projectx_vpc.id
  cidr_block              = var.public_subnet_cidrs[2]
  availability_zone       = var.azs[2]
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project_name}-public_subnet_3"

    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.projectx_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "${var.project_name}-private_subnet_1"
    # Human-readable name for ops and console clarity

    Environment = var.environment
    # Environment identifier (dev/staging/prod) for shared infra and cost tracking

    "kubernetes.io/cluster/${var.project_name}" = "shared"
    # Allows the EKS cluster to use this subnet without owning it (required for shared VPCs)

    "kubernetes.io/role/internal-elb" = "1"
    # Marks this subnet for INTERNAL load balancers and private EKS traffic
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.projectx_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "${var.project_name}-private_subnet_2"

    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.projectx_vpc.id
  cidr_block        = var.private_subnet_cidrs[2]
  availability_zone = var.azs[2]

  tags = {
    Name = "${var.project_name}-private_subnet_3"

    Environment                                 = var.environment
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
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

resource "aws_route_table_association" "public" {
  for_each = {
    "public-1" = aws_subnet.public_subnet_1.id
    "public-2" = aws_subnet.public_subnet_2.id
    "public-3" = aws_subnet.public_subnet_3.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

# This is the private route table without any routes to IGW or NAT Gateways
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.projectx_vpc.id

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "rta_private" {
for_each = {
    "private-1" = aws_subnet.private_subnet_1.id
    "private-2" = aws_subnet.private_subnet_2.id
    "private-3" = aws_subnet.private_subnet_3.id
  }  
  
  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}


# Private subnets and their route tables are used to host internal resources 
# that should not be directly accessible from the internet. 
# In this project, they provide a secure network layer for future services 
# like EKS worker nodes or databases, ensuring traffic stays internal unless explicitly allowed.