# Workload Specific Security Group
resource "aws_security_group" "workload_security_group" {
  provider    = aws.workload
  name        = "workload_traffic"
  description = "Workload Traffic"
  vpc_id      = aws_vpc.core_vpc.id
}

resource "aws_security_group_rule" "allow_workload_egress" {
  provider          = aws.workload
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  self              = true # This allows egress between hosts within the same SG
  security_group_id = aws_security_group.workload_security_group.id
}

# Typically, we'd associate the agent and the AD SG to any instances, but lets also demonstrate cross account security groups
resource "aws_security_group_rule" "additional_monitoring_rule" {
  provider          = aws.workload
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.workload_security_group.id
  # This would typically be a cross account lookup. We just luckily have a reference in this TF module
  source_security_group_id = "${local.shared_vpc_account_id}/${aws_security_group.monitoring_traffic.id}" 
}