resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm_cpu" {
  count               = "${var.instance_count}"
  alarm_name          = "${var.cpu_metric_desc} - ${element(aws_instance.ec2.*.tags.Name, count.index)}"
  comparison_operator = "${var.cpu_comparison_operator}"
  evaluation_periods  = "${var.cpu_evaluation_periods}"
  datapoints_to_alarm = "${var.cpu_datapoints_to_alarm}"
  metric_name         = "${var.cpu_metric_name}"
  namespace           = "${var.cpu_namespace}"
  period              = "${var.cpu_period}"
  statistic           = "${var.cpu_statistic}"
  threshold           = "${var.cpu_threshold}"
  unit                = "${var.cpu_unit}"
  treat_missing_data  = "${var.cpu_treat_missing_data}"
  alarm_description   = "${var.cpu_alarm_action} - ${element(aws_instance.ec2.*.tags.Name, count.index)}"

  dimensions {
    InstanceId = "${element(aws_instance.ec2.*.id, count.index)}"
  }

  #alarm_actions = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.cpu_sns_topic}"]
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm_disk" {
  count               = "${var.instance_count}"
  alarm_name          = "${var.disk_metric_desc} - C - ${element(aws_instance.ec2.*.tags.Name, count.index)}"
  comparison_operator = "${var.disk_comparison_operator}"
  evaluation_periods  = "${var.disk_evaluation_periods}"
  datapoints_to_alarm = "${var.disk_datapoints_to_alarm}"
  metric_name         = "C.${var.disk_metric_name}"
  namespace           = "${var.disk_namespace}"
  period              = "${var.disk_period}"
  statistic           = "${var.disk_statistic}"
  threshold           = "${var.disk_threshold}"
  unit                = "${var.disk_unit}"
  treat_missing_data  = "${var.disk_treat_missing_data}"
  alarm_description   = "${var.disk_alarm_action} - C - ${element(aws_instance.ec2.*.tags.Name, count.index)}"

  dimensions {
    InstanceId = "${element(aws_instance.ec2.*.id, count.index)}"
  }

  #alarm_actions = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.disk_sns_topic}"]
  #ok_actions    = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.disk_sns_topic}"]
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_instance_alarm_reboot" {
  count               = "${local.enable_ar}"
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
  count               = "${local.enable_ar}"
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
