variable "vpc_id" {
  description = "vpc to standup DC in."
  type        = string
}

variable "subnet_id" {
  description = "subnet to standup DC in."
  type        = string
}

variable "domain_member_security_group" {
  description = "Baseline DC security group id."
  type        = string
}

variable "monitoring_security_group" {
  description = "Security Monitoring Group (with account id)."
  type        = string
}