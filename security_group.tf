# Create a security group to allow SSH traffic
resource "aws_security_group" "allow_all" {
  name = "allow_all_sg"
  description = "Allow all traffic"
  vpc_id = "${aws_vpc.default_vpc.id}"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}