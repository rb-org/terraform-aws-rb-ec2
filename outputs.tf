output "instance_id" {
  value = ["${aws_instance.ec2.*.id}"]
}

output "subnet_id" {
  value = ["${aws_instance.ec2.*.subnet_id}"]
}

output "instance_name" {
  value = ["${aws_instance.ec2.*.tags.Name}"]
}

output "instance_tags" {
  value = ["${aws_instance.ec2.*.tags}"]
}
