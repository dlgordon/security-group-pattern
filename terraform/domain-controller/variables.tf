variable "win_username" {
  description = "Windows Host default username to use"
  type        = string
  default     = "demo_admin"
}

variable "win_password" {
  description = "Windows Host default password to use"
  type        = string
}

variable "subnet_id" {
  description = "subnet to standup DC in."
  type        = string
}

variable "security_group_id" {
  description = "Baseline DC security group id."
  type        = string
}