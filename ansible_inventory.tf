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