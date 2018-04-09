variable "instance_name" {}

variable "use_prv_ip" {
  default = "false"
}

variable "instance_type" {
  description = "The type of the instance"
  default     = "t2.micro"
}

variable "instance_count" {
  description = "The number of instances"
  default     = "1"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance. By default it is the AMI: CIS Microsoft Windows Server 2016 Benchmark 1.0.0.9 Level 1"
  default     = ""
}

variable "key_pair" {
  description = "Key pair to be provisioned on the instance"
}

variable "availability_zone" {
  type    = "list"
  default = [""]
}

variable "private_ip" {
  default = 0
}

variable "additional_ip" {
  type    = "list"
  default = []
}

variable "root_volume_type" {
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  default     = "10"
}

variable "root_iops" {
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set to `io1`"
  default     = "0"
}

variable "root_delete_on_termination" {
  description = "Whether the root volume should be destroyed on instance termination"
  default     = "true"
}

variable "ebs_volume" {
  description = "The EBS volumes. Should be defined as map with the device name as key ({ '/dev/xvdb' = { type = 'gp2', size = '100' } }"
  type        = "map"
  default     = {}
}

variable "ebs_volume_name" {
  description = "The EBS volume Name tag"
  default     = ""
}

variable "ebs_volume_type" {
  description = "The type of EBS volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in gigabytes"
  default     = "10"
}

variable "ebs_volume_del_on_term" {
  description = "Delete the volume on instance termination"
  default     = "false"
}

variable "ebs_iops" {
  description = "Amount of provisioned IOPS. This must be set with a volume_type of io1"
  default     = "0"
}

variable "ebs_optimized" {
  description = "Launched EC2 instance will be EBS-optimized"
  default     = "false"
}

variable "user_data" {
  description = "Instance user data. Do not pass gzip-compressed data via this argument"
  default     = ""
}

variable "subnet_ids" {
  description = "List of VPC Subnet IDs the instance is launched in"
  type        = "list"
  default     = []
}

variable "security_group_ids" {
  description = "List of Security Group IDs allowed to connect to the instance"
  type        = "list"
  default     = []
}

variable "app_id" {
  description = "The identifier of the application running on the instance"
  default     = ""
}

variable "app_role" {
  description = "The identifier of the application running on the instance"
  default     = ""
}

variable "passport_enabled" {
  description = "Whether Passport is enabled on the instance"
  default     = "false"
}

variable "chef_enabled" {
  description = "Whether Chef is enabled on the instance"
  default     = "true"
}

variable "backup_enabled" {
  description = "Whether the instance get snapshot"
  default     = ""
}

variable "public_ip" {
  description = "Assign a public ip true/false"
  default     = "false"
}

variable "enable_monitoring" {
  description = "Enable/disable instance monitoring"
  default     = "true"
}

variable "disable_api_termination" {
  description = "Enable/disable API protection"
  default     = "false"
}

variable "patch_group" {
  description = "Patching Group"
  default     = "Windows"
}

variable "patching_day1" {
  description = "Patching Day 1"
  default     = "Tuesday"
}

variable "patching_day2" {
  description = "Patching Day 2"
  default     = "Saturday"
}

variable "autorecovery_enabled" {
  description = "Tag to enable/disable autorecovery module for this instance"
  default     = "True"
}

variable "workload" {
  description = "Tag to identify which application workload is being run: exol, mgmt, rctv..."
  default     = ""
}

variable "countrycode" {
  description = "Tag to identify which country is running on the instance"
  default     = "xx"
}

variable "instance_profile_name" {
  description = "Instance Role profile name"
  default     = ""
}

variable "default_tags" {
  description = "Default tags"
  type        = "map"
}

##### CLOUD WATCH CPU #####

variable "cpu_metric_desc" {
  description = "Metric description, e.g. EC2 CPU Utilization"
  default     = "EC2 CPU Utilization"
}

variable "cpu_alarm_action" {
  description = "Alarm action description e.g. Cleanup / Increase size of disk"
  default     = "EC2 CPU Utilization"
}

variable "cpu_comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "cpu_evaluation_periods" {
  default = "12"
}

variable "cpu_datapoints_to_alarm" {
  default = "12"
}

variable "cpu_namespace" {
  default = "AWS/EC2"
}

variable "cpu_period" {
  default = "300"
}

variable "cpu_statistic" {
  default = "Average"
}

variable "cpu_threshold" {
  default = "70"
}

variable "cpu_unit" {
  default = ""
}

variable "cpu_metric_name" {
  default = "CPUUtilization"
}

variable "cpu_treat_missing_data" {
  default = "breaching"
}

variable "cpu_sns_topic" {
  default = "rackspace-support-urgent"
}

##### CLOUD WATCH DISK SPACE #####

variable "disk_metric_desc" {
  description = "Metric description, e.g. Low Disk Space - System Disks"
  default     = "Low Disk Space - System Disks"
}

variable "disk_alarm_action" {
  description = "Alarm action description e.g. Cleanup / Increase size of disk"
  default     = "Cleanup / Increase size of disk"
}

variable "disk_comparison_operator" {
  default = "LessThanThreshold"
}

variable "disk_evaluation_periods" {
  default = "5"
}

variable "disk_datapoints_to_alarm" {
  default = "5"
}

variable "disk_namespace" {
  default = "Windows/Default"
}

variable "disk_period" {
  default = "60"
}

variable "disk_statistic" {
  default = "Average"
}

variable "disk_threshold" {
  default = "25"
}

variable "disk_unit" {
  default = ""
}

variable "disk_metric_name" {
  default = "FreeDiskPercentage"
}

variable "disk_treat_missing_data" {
  default = "breaching"
}

variable "disk_sns_topic" {
  default = "rackspace-support-urgent"
}
