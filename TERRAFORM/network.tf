resource "aws_vpc" "upgrad-rakesh-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "upgrad-rakesh-vpc"
  }
}

resource "aws_internet_gateway" "upgrad-rakesh-igw" {
  vpc_id = aws_vpc.upgrad-rakesh-vpc.id

  tags = {
    Name = "upgrad-rakesh-vpc"
  }
}

resource "aws_eip" "upgrad-rakesh-eip" {
  vpc = true

  tags = {
    Name = "upgrad-rakesh-eip"
  }
}

resource "aws_nat_gateway" "upgrad-rakesh-natgw" {
  allocation_id = aws_eip.upgrad-rakesh-eip.id
  subnet_id     = aws_subnet.upgrad-rakesh-subnet-pb-a.id
  depends_on    = [aws_internet_gateway.upgrad-rakesh-igw]

  tags = {
    Name = "upgrad-rakesh-natgw"
  }
}

resource "aws_subnet" "upgrad-rakesh-subnet-pb-a" {
  vpc_id                  = aws_vpc.upgrad-rakesh-vpc.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "upgrad-rakesh-subnet-pb-a"
  }
}

resource "aws_subnet" "upgrad-rakesh-subnet-pb-b" {
  vpc_id                  = aws_vpc.upgrad-rakesh-vpc.id
  cidr_block              = "10.0.102.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "upgrad-rakesh-subnet-pb-b"
  }
}

resource "aws_subnet" "upgrad-rakesh-subnet-pt-a" {
  vpc_id                  = aws_vpc.upgrad-rakesh-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "upgrad-rakesh-subnet-pt-a"
  }
}

resource "aws_subnet" "upgrad-rakesh-subnet-pt-b" {
  vpc_id                  = aws_vpc.upgrad-rakesh-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "upgrad-rakesh-subnet-pt-b"
  }
}

resource "aws_route_table" "upgrad-rakesh-rt-pb" {
  vpc_id = aws_vpc.upgrad-rakesh-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.upgrad-rakesh-igw.id
  }

  tags = {
    Name = "upgrad-rakesh-rt-pb"
  }
}

resource "aws_route_table" "upgrad-rakesh-rt-pt" {
  vpc_id = aws_vpc.upgrad-rakesh-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.upgrad-rakesh-natgw.id
  }

  tags = {
    Name = "upgrad-rakesh-rt-pt"
  }
}

resource "aws_route_table_association" "upgrad-rakesh-rta-pb-a" {
  subnet_id      = aws_subnet.upgrad-rakesh-subnet-pb-a.id
  route_table_id = aws_route_table.upgrad-rakesh-rt-pb.id
}

resource "aws_route_table_association" "upgrad-rakesh-rta-pb-b" {
  subnet_id      = aws_subnet.upgrad-rakesh-subnet-pb-b.id
  route_table_id = aws_route_table.upgrad-rakesh-rt-pb.id
}

resource "aws_route_table_association" "upgrad-rakesh-rta-pt-a" {
  subnet_id      = aws_subnet.upgrad-rakesh-subnet-pt-a.id
  route_table_id = aws_route_table.upgrad-rakesh-rt-pt.id
}

resource "aws_route_table_association" "upgrad-rakesh-rta-pt-b" {
  subnet_id      = aws_subnet.upgrad-rakesh-subnet-pt-b.id
  route_table_id = aws_route_table.upgrad-rakesh-rt-pt.id
}
