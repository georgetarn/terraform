data  "template_file" "inventory" {
    template = "${file("./files/ansible_inventory.template")}"
    vars = {
        nodes = "${join("\n", formatlist("%s ansible_host=%s", aws_instance.ec2_instance.*.tags.Backend, aws_instance.ec2_instance.*.public_ip))}"
    }
}

resource "local_file" "inventory-generated" {
  content  = "${data.template_file.inventory.rendered}"
  filename = "./ansible/inventory-generated"
}


resource "null_resource" "ensure_connectivity" {
  count           = "${var.count_ec2_instance_nodes}"

  triggers = {
    nodes_created  = "${join(",", aws_instance.ec2_instance.*.id)}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host = "${aws_instance.ec2_instance.*.public_ip[count.index]}"
    private_key = "${tls_private_key.tls_key.private_key_pem}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y"
    ]
  }
}

# Trigger ansible provisioning when all the nodes have connectivity
resource "null_resource" "ansible" {
  triggers = {
    nodes_created  = "${join(",", null_resource.ensure_connectivity.*.id)}"
    inventory_created = "${local_file.inventory-generated.id}"
  }

  provisioner "local-exec" {
      working_dir = "ansible"
      command = "ansible-playbook -i inventory-generated sensu-cluster-playbook.yml -v"
  }
}