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
    Name = "${var.prefix}_default_vpc"
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
    Name = "${var.prefix}_subnet_${count.index}"
  }
}

# Internet gateway to route the traffic from internet to our VPC
resource "aws_internet_gateway" "default_internet_gw" {
  vpc_id = "${aws_vpc.default_vpc.id}"

  tags = {
      Name = "${var.prefix}_default_internet_gw"
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
      Name = "${var.prefix}_default_routing_table"
  }
}

# Associate the route table to our subnets
resource "aws_route_table_association" "subnet_association" {
  count = "${var.availability_zones}"
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.default_routing_table.id}"
}



# Network Load Balancer
resource "aws_lb" "load_balancer" {
  count              = "${var.include_lb ? 1 : 0}"
  name               = "${var.prefix}-network-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = "${aws_subnet.subnets.*.id}"

  # enable_deletion_protection = true
}

# IP target group
resource "aws_lb_target_group" "ip_target_group" {
  count       = "${var.include_lb ? 1 : 0}"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = "${aws_vpc.default_vpc.id}"
}

resource "aws_lb_target_group_attachment" "target_group_attachement" {
  count = "${var.include_lb ? var.count_ec2_instance_nodes : 0}"
  target_group_arn = "${aws_lb_target_group.ip_target_group[0].arn}"
  target_id        = "${element(aws_instance.ec2_instance.*.private_ip, count.index)}"
}

resource "aws_lb_listener" "lb_listener" {
  count       = "${var.include_lb ? 1 : 0}"
  load_balancer_arn = "${aws_lb.load_balancer[0].arn}"
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.ip_target_group[0].arn}"
  }
}