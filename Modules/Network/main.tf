# -------------------------------------------------------------------------------------------------------------
#   ROOT MODULE
# --------------------------------------------------------------------------------------------------------------
# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "AWS-3-tier-vpc" {
  cidr_block           = var.VPC_cider_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# create an Internet Gateway
resource "aws_internet_gateway" "project-igw" {
  vpc_id = aws_vpc.AWS-3-tier-vpc.id
  tags = {
    Name = "project_IGW"
  }
}

# Create subnets in 1a
resource "aws_subnet" "public-subnet-az-1a" {
  vpc_id            = aws_vpc.AWS-3-tier-vpc.id
  cidr_block        = var.public_subnet_1a_cider_block
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_subnet" "private-subnet-az-1a" {
  vpc_id            = aws_vpc.AWS-3-tier-vpc.id
  cidr_block        = var.private_subnet_1a_cider_block
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private-subnet-1a"
  }
}

# Create subnets in az 1b
resource "aws_subnet" "public-subnet-az-1b" {
  vpc_id     = aws_vpc.AWS-3-tier-vpc.id
  cidr_block = var.public_subnet_1b_cider_block

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "public-subnet-1b"
  }
}

resource "aws_subnet" "private-subnet-az-1b" {
  vpc_id            = aws_vpc.AWS-3-tier-vpc.id
  cidr_block        = var.private_subnet_1b_cider_block
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "private-subnet-1a"
  }
}

# Database subnets
# resource "aws_subnet" "db-subnet-1a" {
#   vpc_id     = aws_vpc.AWS-3-tier-vpc.id
#   cidr_block = "10.0.100.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "database-sub-01"
#   }
# }

# resource "aws_subnet" "db-subnet-1b" {
#   vpc_id     = aws_vpc.AWS-3-tier-vpc.id
#   cidr_block = "10.0.200.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "database-sub-01"
#   }
# }

# create a public route table
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.AWS-3-tier-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-igw.id
  }


  tags = {
    Name = "Public-RT"
  }
}

# create private route table
# resource "aws_route_table" "p-RT-1a" {
#   vpc_id = aws_vpc.AWS-3-tier-vpc.id

#   route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = aws_nat_gateway.nat-1a.id
#   }

#   tags = {
#     Name = "Private-RT-sun-1a"
#   }
# }

resource "aws_route_table" "private-RT-1b" {
  vpc_id = aws_vpc.AWS-3-tier-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-1b.id
  }

  tags = {
    Name = "Private-RT-sub-1b"
  }
}

# public Associate route table to the subnet
resource "aws_route_table_association" "public-assoc-1a" {
  subnet_id      = aws_subnet.public-subnet-az-1a.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "public-assoc-1b" {
  subnet_id      = aws_subnet.private-subnet-az-1a.id
  route_table_id = aws_route_table.public-RT.id
}


# private Associate route table to the subnet
# resource "aws_route_table_association" "private-assoc-1a" {
#   subnet_id      = aws_subnet.private-subnet-az-1a.id
#   route_table_id = aws_route_table.private-RT-1b.id
# }

resource "aws_route_table_association" "private-assoc-1b" {
  subnet_id      = aws_subnet.private-subnet-az-1b.id
  route_table_id = aws_route_table.private-RT-1b.id
}


# NAT Gateway
# resource "aws_nat_gateway" "nat-1a" {
#   connectivity_type = "private"
#   subnet_id         = aws_subnet.public-subnet-1a.id
#   depends_on = [aws_internet_gateway.project-igw]
# }


resource "aws_nat_gateway" "nat-1b" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.public-subnet-az-1b.id
  depends_on        = [aws_internet_gateway.project-igw]
}
