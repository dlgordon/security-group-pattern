terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Workload Specific Security Group
resource "aws_security_group" "workload_security_group" {
  name        = "workload_traffic"
  description = "Workload Traffic"
  vpc_id      = var.vpc_id
}

# If we have the security group ID, we can add a rule from another account here
resource "aws_security_group_rule" "allow_monitoring_daemons" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Ingress from Monitoring agents"
  security_group_id        = aws_security_group.workload_security_group.id
  source_security_group_id = var.monitoring_security_group
}


# standup windows 2019 workload host
resource "aws_instance" "windows_2019_host" {
  ami                    = "ami-08e49cb12f5231fd8" # https://aws.amazon.com/marketplace/server/configuration?productId=ef297a90-3ad0-4674-83b4-7f0ec07c39bb&ref_=psb_cfg_continue
  instance_type          = "t3.small"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.domain_member_security_group, aws_security_group.workload_security_group.id]
  #   provisioner "local-exec" {
  #     working_dir = "ansible"
  #     command     = "sleep 120;cp hosts.default hosts; sed -i '' 's/PUBLICIP/${aws_instance.windows_2016_dc.public_ip}/g' hosts;ansible-playbook -i hosts playbooks/windows_dc.yml"
  #   }
}