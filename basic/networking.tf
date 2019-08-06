# Declare the data source to list all the availability zones
# for the region configured in the provider
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a default VPC
resource "aws_vpc" "default_vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "default_test"
  }
}

# Create a x.x.x.x/24 subnet in this VPC in the first availability zone
resource "aws_subnet" "subnets" {
  count = "${var.availability_zones}"
  cidr_block = "${cidrsubnet(aws_vpc.default_vpc.cidr_block, 8, count.index )}"
  vpc_id = "${aws_vpc.default_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "subnet_${count.index}"
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

# Associate the route table to our subnets
resource "aws_route_table_association" "subnet_association" {
  count = "${var.availability_zones}"
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.default_routing_table.id}"
}