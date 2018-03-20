data "aws_ami" "default" {
  most_recent = "true"

  filter {
    name   = "owner-alias"
    values = ["aws-marketplace"]
  }

  filter {
    name   = "name"
    values = ["CIS Microsoft Windows Server 2016 Benchmark 1.0.0.9 Level 1-*"]
  }

  owners = ["679593333241"]
}

data "aws_ami" "info" {
  filter {
    name   = "image-id"
    values = ["${local.ami_id}"]
  }
}

data "aws_region" "current" {
  name = "${var.region}"
}

data "aws_caller_identity" "current" {}

data "template_file" "ec2_userdata" {
  count    = "${var.instance_count}"
  template = "${local.user_data}"

  vars {
    MachineName = "${upper(var.environment)}${upper(var.app_id)}${upper(format("%02d", count.index + 1))}"
  }
}

/*
data "aws_subnet" "selected" {
  count = "${length(var.subnet)}"
  id    = "${var.subnet[count.index]}"
}
*/

