# This sits in the shared network account (VPC owner)
resource "aws_security_group" "monitoring_traffic" {
  provider    = aws.network
  name        = "baseline_sg_monitoring"
  description = "Monitoring Agents and Daemons"
  vpc_id      = aws_vpc.core_vpc.id
}

# Sec Group Rule item are created as they support tagging by the API
# Hopefully TF catches up
resource "aws_security_group_rule" "allow_all_out" {
  provider          = aws.network
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.monitoring_traffic.id
}

