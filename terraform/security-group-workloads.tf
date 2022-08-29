# This security group (which would live as a blueprinted group per account, via a stackset), allows domain comms egress
# to just the domain controller security group. Again, statefulness works for us, as there is no explicit egress granted
# on the target SG, but it should work none-the-less
# Note we can reference cross account SG's in rules by pre-pending the account number
resource "aws_security_group" "workload_account_domain_member_security_group" {
  provider    = aws.workload
  name        = "baseline_active_directory_domain_member"
  description = "Workload Account Domain Member"
  vpc_id      = aws_vpc.core_vpc.id

  egress {
    from_port       = 3268
    to_port         = 3269
    protocol        = "tcp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "Global Catalog"
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "icmp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "ICMP"
  }
  egress {
    from_port       = 389
    to_port         = 389
    protocol        = "tcp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "LDAP Server"
  }
  egress {
    from_port       = 389
    to_port         = 389
    protocol        = "udp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "LDAP Server"
  }
  egress {
    from_port       = 636
    to_port         = 636
    protocol        = "tcp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "LDAP Server (SSL)"
  }
  egress {
    from_port       = 445
    to_port         = 445
    protocol        = "tcp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "SMB"
  }
  egress {
    from_port       = 135
    to_port         = 135
    protocol        = "tcp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "RPC"
  }
  egress {
    from_port       = 1024
    to_port         = 5000
    protocol        = "tcp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "RPC randomly allocated tcp high ports"
  }
  egress {
    from_port       = 49152
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "RPC randomly allocated tcp high ports"
  }

  egress {
    from_port       = 88
    to_port         = 88
    protocol        = "tcp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "Kerberos/TCP"
  }

  egress {
    from_port       = 88
    to_port         = 88
    protocol        = "udp"
    security_groups = ["${local.active_direct_account_id}/${aws_security_group.active_directory_security_group_dc2dc.id}"]
    description     = "Kerberos/UDP"
  }
}
