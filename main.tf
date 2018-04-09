locals {
  # user_data        = "${var.user_data != "" ? var.user_data : "${file("${path.module}/userdata_ec2.ps1")}"}"
  root_volume_type = "${var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.info.root_device_type}"
  root_iops        = "${var.root_volume_type == "io1" ? var.root_iops : "0"}"
  enable_ar        = "${var.autorecovery_enabled == "true" ? var.instance_count : "0"}"
}

// Elastic IP
resource "aws_eip" "eip_main" {
  count    = "${var.public_ip ? var.instance_count : 0}"
  instance = "${element(aws_instance.ec2.*.id, count.index)}"
  vpc      = true
}

/*
data "null_data_source" "calc_ip" {
  count = "${length(var.additional_ip)}"

  inputs = {
    additional_ip_adr = "${cidrhost(element(data.aws_subnet.subnet_info.*.cidr_block, count.index), element(var.additional_ip, count.index))}"
  }
}

// Optional aditional network interface
resource "aws_network_interface" "additional_network_interface" {
  count     = "${var.instance_count * (length(var.additional_ip) != 0 ? 1 : 0)}"
  subnet_id = "${element(data.aws_subnet.subnet_info.*.id, count.index)}"
  private_ips     = ["${data.null_data_source.calc_ip.inputs}"]
  security_groups = ["${var.security_group_ids}"]
  description     = "Aditional network interface with static private IP address"

  tags {
    Name = "${element(aws_instance.ec2.*.tags.Name, (count.index + 1))}"
  }
}

resource "aws_network_interface_attachment" "additional_network_interface_attachment" {
  count                = "${var.instance_count * (length(var.additional_ip) != 0 ? 1 : 0)}"
  instance_id          = "${element(aws_instance.ec2.*.id, (count.index))}"
  network_interface_id = "${element(aws_network_interface.additional_network_interface.*.id, count.index)}"
  device_index         = "${count.index}"
}

*/

/*
resource "aws_network_interface" "additional_network_interface" {
  count           = "${var.instance_count * length(var.additional_ip)}"
  subnet_id       = "${element(data.aws_subnet.subnet_info.*.id, (count.index + 1) / length(var.additional_ip))}"
  private_ips     = ["${cidrhost(element(data.aws_subnet.subnet_info.*.cidr_block, (count.index + 1) / length(var.additional_ip)), element(var.additional_ip, count.index))}"]
  security_groups = ["${var.security_group_ids}"]
  description     = "Aditional network interface with static private IP address"

  tags {
    Name = "${element(aws_instance.ec2.*.tags.Name, (count.index + 1) / length(var.ebs_volume))}"
  }


resource "aws_network_interface_attachment" "additional_network_interface_attachment" {
  count                = "${var.instance_count * length(var.additional_ip)}"
  instance_id          = "${element(aws_instance.ec2.*.id, (count.index + 1) / length(var.additional_ip))}"
  network_interface_id = "${element(aws_network_interface.additional_network_interface.*.id, count.index)}"
  device_index         = "${count.index}"
}
}*/

// EC2 instance
resource "aws_instance" "ec2" {
  count                  = "${var.instance_count}"
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${element(data.aws_subnet.subnet_info.*.id, count.index)}"
  iam_instance_profile   = "${var.instance_profile_name}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  key_name               = "${var.key_pair}"

  # use_prv_ip
  private_ip = "${var.use_prv_ip == "true" ? cidrhost(element(data.aws_subnet.subnet_info.*.cidr_block, count.index), var.private_ip) : ""}"

  # "${length(var.private_ip) != 0 ? cidrhost(element(data.aws_subnet.subnet_info.*.cidr_block, count.index), var.private_ip) : ""}"

  availability_zone       = "${length(var.availability_zone) != 0 ? element(var.availability_zone, count.index) : element(data.aws_availability_zones.available.names, count.index)}"
  monitoring              = "${var.enable_monitoring}"
  ebs_optimized           = "${var.ebs_optimized}"
  disable_api_termination = "${var.disable_api_termination}"
  user_data               = "${element(data.template_file.ec2_userdata.*.rendered, count.index)}"
  root_block_device {
    volume_type           = "${local.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
    iops                  = "${local.root_iops}"
    delete_on_termination = "${var.root_delete_on_termination}"
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["user_data", "ami"]
  }
  tags = "${merge(var.default_tags,
    map("Name",                   "${var.instance_name}-${format("%02d", count.index+01)}"),
    map("AppID",                  "${var.app_id}"),
    map("AppRole",                "${var.app_role}"),
    map("Environment",            "${terraform.workspace}"),
    map("Backup ",                "${var.backup_enabled}"),
    map("Version",                ""),
    map("AutomationUsed",         "TFM"),
    map("IsPII",                  ""),
    map("Owner",                  ""),
    map("CreatedBy",              "Exact"),
    map("BusinessUnit",           ""),
    map("CostCentre",             ""),
    map("Budget",                 ""),
    map("Project",                ""),
    map("Team",                   ""),
    map("PassportEnabled",        "${var.passport_enabled}"),
    map("ChefEnabled",            "${var.chef_enabled}"),
    map("PatchGroup",             "${var.patch_group}"),
    map("PatchingDay",            "${count.index%2 == "0" ? "${var.patching_day1}" : "${var.patching_day2}"}"),
    map("AutoRecovery",           "${var.autorecovery_enabled}"),
    map("Workload   ",            "${var.workload}"),
    map("CountryCode",            "${var.countrycode}")
    )
  }"
}

resource "aws_ebs_volume" "ec2_volume" {
  count             = "${var.instance_count * length(var.ebs_volume)}"
  availability_zone = "${element(aws_instance.ec2.*.availability_zone, (count.index + 1) / length(var.ebs_volume))}"
  type              = "${lookup(var.ebs_volume[element(keys(var.ebs_volume), count.index)], "type", var.ebs_volume_type)}"
  size              = "${lookup(var.ebs_volume[element(keys(var.ebs_volume), count.index)], "size", var.ebs_volume_size)}"
  iops              = "${lookup(var.ebs_volume[element(keys(var.ebs_volume), count.index)], "iops", var.ebs_iops)}"
  encrypted         = "true"

  tags {
    Name = "${element(aws_instance.ec2.*.tags.Name, (count.index + 1) / length(var.ebs_volume))}-${lookup(var.ebs_volume[element(keys(var.ebs_volume), count.index)], "name", var.ebs_volume_name)}"
  }
}

resource "aws_volume_attachment" "ec2_volume_attachment" {
  count       = "${var.instance_count * length(var.ebs_volume)}"
  device_name = "${element(keys(var.ebs_volume), count.index)}"
  volume_id   = "${element(aws_ebs_volume.ec2_volume.*.id, count.index)}"
  instance_id = "${element(aws_instance.ec2.*.id, (count.index + 1) / length(var.ebs_volume))}"
}
