# Domain member (and server) group
resource "aws_security_group" "active_directory_security_group" {
  provider    = aws.ad
  name        = "baseline_active_directory"
  description = "Active Directory Traffic"
  vpc_id      = aws_vpc.core_vpc.id
}

resource "aws_security_group_rule" "allow_ad_egress" {
  provider          = aws.ad
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  self              = true # This allows egress between hosts within the same SG
  security_group_id = aws_security_group.active_directory_security_group.id
}

resource "aws_security_group_rule" "allow_ad_tcp_ingress" {
  for_each           = toset(local.active_directory_tcp_ports)
  provider          = aws.ad
  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  self              = true # This allows egress between hosts within the same SG
  security_group_id = aws_security_group.active_directory_security_group.id
}

resource "aws_security_group_rule" "allow_ad_udp_ingress" {
  for_each           = toset(local.active_directory_udp_ports)
  provider          = aws.ad
  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "udp"
  self              = true # This allows egress between hosts within the same SG
  security_group_id = aws_security_group.active_directory_security_group.id
}
