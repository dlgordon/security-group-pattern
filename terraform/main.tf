terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "> 4.0.0"
      configuration_aliases = [aws.ad, aws.network, aws.workload]
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