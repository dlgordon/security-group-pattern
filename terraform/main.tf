terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "> 4.0.0"
      configuration_aliases = [aws.ad, aws.network, aws.workload]
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "ad"
  assume_role {
    role_arn = "arn:aws:iam::${local.active_direct_account_id}:role/${local.deployment_role_name}"
  }
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "network"
  assume_role {
    role_arn = "arn:aws:iam::${local.shared_vpc_account_id}:role/${local.deployment_role_name}"
  }
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "workload"
  assume_role {
    role_arn = "arn:aws:iam::${local.workload_account_id}:role/${local.deployment_role_name}"
  }
}

data "aws_caller_identity" "current" {}

resource "random_string" "domain_admin_password" {
  length  = 16
  special = false

}

module "domain-controller" {
  providers = {
    aws = aws.ad
  }
  source            = "./domain-controller"
  win_username      = "domain_admin"
  win_password      = random_string.domain_admin_password.id
  subnet_id         = aws_subnet.core_subnet_a.id
  security_group_id = aws_security_group.active_directory_security_group_dc2dc.id
}

module "domain-member-workload" {
  providers = {
    aws = aws.workload
  }
  source                       = "./workload"
  vpc_id                       = aws_vpc.core_vpc.id
  subnet_id                    = aws_subnet.core_subnet_b.id
  domain_member_security_group = aws_security_group.workload_account_domain_member_security_group.id
  monitoring_security_group    = "${local.shared_vpc_account_id}/${aws_security_group.monitoring_traffic.id}"
}
