data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.prefix}_ec2_instance_key"
  public_key = "${tls_private_key.tls_key.public_key_openssh}"
}

resource "local_file" "public_key_openssh" {
  content  = "${tls_private_key.tls_key.public_key_openssh}"
  filename = "keys/id_rsa.pub"
}
resource "local_file" "private_key_pem" {
  content  = "${tls_private_key.tls_key.private_key_pem}"
  filename = "keys/id_rsa"
  provisioner "local-exec" {
    command = "chmod 400 keys/id_rsa"
  }
}

resource "aws_instance" "ec2_instance" {
  count           = "${var.count_ec2_instance_nodes}"
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${var.ec2_instance_node_type}"
  key_name        = "${aws_key_pair.ec2_key.key_name}"
  security_groups = ["${aws_security_group.allow_all.id}"]
  user_data       = "${data.template_cloudinit_config.ec2_cloudinit.rendered}"

  # Networking
  subnet_id       = "${aws_subnet.subnets.*.id[count.index % var.availability_zones]}"
  #private_ip      = "x.x.x.x${count.index}"
  source_dest_check = true # enable for NAT interfaces

  # Node may have a xGiB root block device
  # root_block_device {
  #   volume_size = "x"
  #   volume_type = "gp2"
  # }

  tags = {
    Name = "${var.prefix}_ec2_instance_${count.index}"
  }
}

data "template_cloudinit_config" "ec2_cloudinit" {
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.provision_ec2_node.rendered}"
  }
}

data "template_file" "provision_ec2_node" {
  template = "${file("files/provision_ec2_node.sh")}"
}