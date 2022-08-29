# This is the domain controller security group
# Limit scope to the CIDR of the VPC
# The assumption being that other accounts will have a SG that allows egress
# to this VPC. Given statefulness of SG's, we dont need to define egress
# in this SG, beyond a self referential egress to 
# allow all _domain controllers_ that share this SG to communicate
resource "aws_security_group" "active_directory_security_group_dc2dc" {
  provider    = aws.ad
  name        = "baseline_active_directory_domain_controller"
  description = "Active Directory Traffic"
  vpc_id      = aws_vpc.core_vpc.id

  ingress {
    from_port   = 3268
    to_port     = 3269
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "Global Catalog"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "ICMP"
  }
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "LDAP Server"
  }
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "udp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "LDAP Server"
  }
  ingress {
    from_port   = 636
    to_port     = 636
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "LDAP Server (SSL)"
  }
  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "SMB"
  }
  ingress {
    from_port   = 135
    to_port     = 135
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "RPC"
  }
  ingress {
    from_port   = 1024
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "RPC randomly allocated tcp high ports"
  }
  ingress {
    from_port   = 49152
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "RPC randomly allocated tcp high ports"
  }

  ingress {
    from_port   = 88
    to_port     = 88
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "Kerberos/TCP"
  }

  ingress {
    from_port   = 88
    to_port     = 88
    protocol    = "udp"
    cidr_blocks = [aws_vpc.core_vpc.cidr_block]
    description = "Kerberos/UDP"
  }
  egress {
    from_port = 0
    to_port   = 65535
    protocol  = -1
    self      = true # This allows egress between hosts within the same SG
  }
}
