<powershell>

$node_Name      = (Invoke-WebRequest http://169.254.169.254/latest/meta-data/instance-id).content # this uses the EC2 instance ID as the node name
$az             = (Invoke-WebRequest http://169.254.169.254/latest/meta-data/placement/availability-zone).content

$az_mod         = $az.substring($az.length -1)
$suffix         = $node_Name.substring($node_Name.length -4,4)
$svrName        = "${MachineName}$az_mod-$suffix"

# Change the computer Name
Rename-Computer -newname $svrName -Restart -Force

</powershell>
