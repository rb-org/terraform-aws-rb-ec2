locals {
  ami_id = "${var.ami_id != "" ? var.ami_id : data.aws_ami.default.image_id}"

  #user_data        = "${var.user_data != "" ? "${file(var.user_data)}" : "${file("${path.module}/files/userdata_ec2.ps1")}"}"
  user_data        = "${var.user_data != "" ? "${file(var.user_data)}" : ""}"
  root_volume_type = "${var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.info.root_device_type}"
  root_iops        = "${var.root_volume_type == "io1" ? var.root_iops : "0"}"
}

// Elastic IP
resource "aws_eip" "eip_main" {
  count    = "${var.public_ip ? var.instance_count : 0}"
  instance = "${element(aws_instance.ec2.*.id, count.index)}"
  vpc      = true
}

// EC2 instance
resource "aws_instance" "ec2" {
  count = "${var.instance_count}"

  ami                    = "${local.ami_id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${element(var.subnet, count.index)}"
  iam_instance_profile   = "${var.instance_profile_name}"
  vpc_security_group_ids = ["${var.security_group}"]
  key_name               = "${var.key_pair}"

  #availability_zone       = "${length(var.availability_zone) != 0 ? var.availability_zone[count.index] : data.aws_availability_zones.available.names[count.index]}"
  monitoring              = "${var.enable_monitoring}"
  ebs_optimized           = "${var.ebs_optimized}"
  disable_api_termination = "${var.disable_api_termination}"
  user_data               = "${element(data.template_file.ec2_userdata.*.rendered, count.index)}"
  private_ip              = "${var.private_ip}"
  ebs_block_device        = ["${var.ebs_block_device}"]

  root_block_device {
    volume_type           = "${local.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
    iops                  = "${local.root_iops}"
    delete_on_termination = "${var.root_delete_on_termination}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["user_data"]
  }

  tags {
    Name            = "${var.instance_name}-${format("%02d", count.index+01)}"
    AppID           = "${var.app_id}"
    AppRole         = "${var.app_role}"
    Environment     = "${var.environment}"
    Backup          = "${var.backup_enabled}"
    Version         = ""
    AutomationUsed  = "TFM"
    IsPII           = ""
    Owner           = ""
    CreatedBy       = "Exact"
    BusinessUnit    = ""
    CostCentre      = ""
    Budget          = ""
    Project         = ""
    Team            = ""
    PassportEnabled = "${var.passport_enabled}"
    ChefEnabled     = "${var.chef_enabled}"
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_instance_alarm_reboot" {
  count               = "${var.instance_count}"
  alarm_name          = "${element(aws_instance.ec2.*.tags.Name, count.index)}-StatusCheckFailedInstanceAlarmReboot"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "0"
  unit                = "Count"
  alarm_description   = "Status checks have failed, rebooting system"

  dimensions {
    InstanceId = "${element(aws_instance.ec2.*.id, count.index)}"
  }

  alarm_actions = ["arn:aws:swf:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:action/actions/AWS_EC2.InstanceId/Reboot/1.0"]
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_system_alarm_recover" {
  count               = "${var.instance_count}"
  alarm_name          = "${element(aws_instance.ec2.*.tags.Name, count.index)}-StatusCheckFailedSystemAlarmRecover"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "0"
  unit                = "Count"
  alarm_description   = "Status checks have failed for system, recovering instance"

  dimensions {
    InstanceId = "${element(aws_instance.ec2.*.id, count.index)}"
  }

  alarm_actions = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]
}
