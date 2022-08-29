terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
    }
  }
}

# standup windows 2019 domain controller
resource "aws_instance" "windows_2019_dc" {
  ami                    = "ami-08e49cb12f5231fd8" # https://aws.amazon.com/marketplace/server/configuration?productId=ef297a90-3ad0-4674-83b4-7f0ec07c39bb&ref_=psb_cfg_continue
  instance_type          = "t3.small"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  user_data              = <<EOF
<powershell>
$admin = [adsi]("WinNT://./${var.win_username}, user")
$admin.PSBase.Invoke("SetPassword", "${var.win_password}")
Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))
</powershell>
EOF

  #   provisioner "local-exec" {
  #     working_dir = "ansible"
  #     command     = "sleep 120;cp hosts.default hosts; sed -i '' 's/PUBLICIP/${aws_instance.windows_2016_dc.public_ip}/g' hosts;ansible-playbook -i hosts playbooks/windows_dc.yml"
  #   }
}