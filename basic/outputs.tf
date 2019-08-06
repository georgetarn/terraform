output "ec2_global_ips" {
  value = "${aws_instance.ec2_instance.*.public_ip}"
}

output "load_balancer" {
  value = "${aws_lb.load_balancer.dns_name}"
}