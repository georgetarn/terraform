# Create a security group to allow SSH traffic
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh_sg"
  description = "Allow SSH inbound traffic on port 22"
  vpc_id = "${aws_vpc.default_vpc.id}"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls_sg"
  description = "Allow TLS inbound traffic on port 443"
  vpc_id = "${aws_vpc.default_vpc.id}"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}