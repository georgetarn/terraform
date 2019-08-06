provider "aws" {
    profile = "${var.profile}"
    shared_credentials_file = "~/.aws/credentials"
  region     = "${var.region}"
}

variable "profile" {
  default     = "xxx"
  description = "AWS local profile credentials"
}

variable "prefix" {
  default     = "yourname"
  description = "Cluster Prefix - All resources created by Terraform have this prefix prepended to them"
}

variable "count_ec2_instance_nodes" {
  default     = "0"
  description = "Number of ec2 nodes"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS Region for deployment"
}

variable "ec2_instance_node_type" {
  default     = "t2.large"
  description = "AWS instance type for the ec2 nodes"
}

variable "ssh_key_name" {
  default     = ""
  description = "AWS Key Pair Name"
}

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

resource "aws_instance" "ec2_instance" {
  count           = "${var.count_ec2_instance_nodes}"
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${var.ec2_instance_node_type}"
  key_name        = "${var.ssh_key_name}"
  security_groups = ["${aws_security_group.allow_all.id}"]
  user_data       = "${data.template_cloudinit_config.ec2_cloudinit.rendered}"

  # Networking
  subnet_id       = "${aws_subnet.default_subnet.id}"
  #private_ip      = "x.x.x.x${count.index}"
  source_dest_check = true # enable for NAT interfaces

  # Node may have a xGiB root block device
  # root_block_device {
  #   volume_size = "x"
  #   volume_type = "gp2"
  # }

  tags = {
    Name = "${var.prefix}-ec2_instance-${count.index}"
  }
}

output "ec2_global_ips" {
  value = ["${aws_instance.ec2_instance.*.public_ip}"]
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
