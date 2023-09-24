provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "devopshint_vpc" {
    cidr_block = "10.0.0.0/18"
  tags={
    Name = "devopshint_vpc VPC"
  }
}


resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.devopshint_vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1a"

    tags={
        Name="Public Subnet"
    }

}

resource "aws_subnet" "private_subnet" {
     vpc_id = aws_vpc.devopshint_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "ap-south-1a"

    tags={
        Name="Private Subnet"
    }
  
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.devopshint_vpc.id
     tags = {
        Name="devopshint_vpc IGW"
     }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.devopshint_vpc.id
    route {   
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name="Public Route Table"
    }
  
}


resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id  
}

























