# Example

```
module "ec2_instance" {
  source = "git@github.com:exactsoftware/xyz-tfm-mods-ec2//default"

  region         = "${var.region}"
  instance_name  = "${var.prefix}-${terraform.workspace}-ec2"
  instance_type  = "t2.medium"
  instance_count = 2
  ami_id         = "${var.ad_ami_id[var.region]}"
  key_pair       = "${var.key_name[var.region]}"

  root_volume_type = "gp2"
  root_volume_size = 50
  user_data               = "./files/userdata_ec2.ps1"
  subnet                  = ["${var.private_subnets}"]
  security_group          = ["${var.win_sg_id}", "${module.sg_sql_svr.this_security_group_id}"]
  environment             = "${terraform.workspace}"
  app_id                  = "sql"
  app_role                = "database"
  passport_enabled        = false
  chef_enabled            = true
  backup_enabled          = false
  public_ip               = false
  enable_monitoring       = true
  disable_api_termination = true
  instance_profile_name   = "${var.instance_profile}"
  private_ip              = 99
  addnl_nic               = true
  addnl_nic_ip            = 101

  ebs_volume = {
    "/dev/xvdb" = {
      type = "gp2"

      size = "10"
    }

    "/dev/xvdc" = {
      type = "gp2"

      size = "10"
    }
  }
}
```