resource "aws_ram_resource_share" "subnet_resource_share" {
  provider                  = aws.network
  name                      = "shared_subnets"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "shared_subnet_a" {
  provider           = aws.network
  resource_arn       = aws_subnet.core_subnet_a.arn
  resource_share_arn = aws_ram_resource_share.subnet_resource_share.arn
}

resource "aws_ram_resource_association" "shared_subnet_b" {
  provider = aws.network

  resource_arn       = aws_subnet.core_subnet_b.arn
  resource_share_arn = aws_ram_resource_share.subnet_resource_share.arn
}

resource "aws_ram_principal_association" "shared_subnet_to_workload" {
  provider           = aws.network
  principal          = local.workload_account_id
  resource_share_arn = aws_ram_resource_share.subnet_resource_share.arn
}

resource "aws_ram_principal_association" "shared_subnet_to_ad" {
  provider           = aws.network
  principal          = local.active_direct_account_id
  resource_share_arn = aws_ram_resource_share.subnet_resource_share.arn
}