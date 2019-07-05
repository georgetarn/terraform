# Create a default VPC
resource "aws_vpc" "default_vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  map_public_ip_on_launch = true

  tags = {
    Name = "default_test"
  }
}

# Create a x.x.x.x/24 subnet in this VPC
resource "aws_subnet" "default_subnet" {
  cidr_block = "${cidrsubnet(aws_vpc.default_vpc.cidr_block, 0, 0)}"
  vpc_id = "${aws_vpc.default_vpc.id}"
  # availability_zone = "us-east-1a"

  tags = {
    Name = "default_test"
  }
}

# Internet gateway to route the traffic from internet to our VPC
resource "aws_internet_gateway" "default_internet_gw" {
  vpc_id = "${aws_vpc.default_vpc.id}"

  tags = {
      Name = "default_test"
  }
}

# Routing table to route traffic from internet to our VPC
resource "aws_route_table" "default_routing_table" {
  vpc_id = "${aws_vpc.default_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default_internet_gw.id}"
  }

  tags = {
      Name = "default"
  }
}

# Associate the route table to our subnet
resource "aws_route_table_association" "default_subnet_association" {
  subnet_id      = "${aws_subnet.default_subnet.id}"
  route_table_id = "${aws_route_table.default_routing_table.id}"
}