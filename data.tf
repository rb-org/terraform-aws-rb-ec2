data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "template_file" "ec2_userdata" {
  count    = "${var.instance_count}"
  template = "${file(var.user_data)}"

  vars {
    MachineName = "${upper(terraform.workspace)}${upper(var.app_id)}${upper(format("%02d", count.index + 1))}"
  }
}

data "aws_availability_zones" "available" {}

data "aws_subnet" "subnet_info" {
  count = "${length(var.subnet_ids)}"
  id    = "${var.subnet_ids[count.index]}"
}

data "aws_ami" "info" {
  filter {
    name   = "image-id"
    values = ["${var.ami_id}"]
  }
}
