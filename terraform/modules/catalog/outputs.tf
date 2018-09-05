output "instance_ips" {
  value = ["${aws_instance.catalog.*.private_ip}"]
}
