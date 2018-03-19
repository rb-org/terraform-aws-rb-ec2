variable "instance_name" {}

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

variable "ebs_volume_type" {
  description = "The type of EBS volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in gigabytes"
  default     = "10"
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

variable "subnet" {
  description = "List of VPC Subnet IDs the instance is launched in"
  type        = "list"
  default     = []
}

variable "security_group" {
  description = "List of Security Group IDs allowed to connect to the instance"
  type        = "list"
  default     = []
}

variable "environment" {
  description = "The environment (e.g. `dev`, `prod1` or `mgt0`)"
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
  default     = "true"
}

variable "chef_enabled" {
  description = "Whether Chef is enabled on the instance"
  default     = "true"
}

variable "backup_enabled" {
  description = "Whether the instance get snapshot"
  default     = ""
}

variable "private_ip" {
  description = "Assign a specific private ip. Only the last octet is needed not the full address"
  default     = ""
}

variable "public_ip" {
  description = "Assign a public ip true/false"
  default     = false
}

variable "enable_monitoring" {
  description = "Enable/disable instance monitoring"
  default     = true
}

variable "disable_api_termination" {
  description = "Enable/disable API protection"
  default     = false
}

variable "instance_profile_name" {
  description = "IAM Role Instance Profile Name"
  default     = ""
}

variable "region" {}

variable "ebs_block_device" {
  type    = "list"
  default = []
}
