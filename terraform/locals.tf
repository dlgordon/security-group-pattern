locals {
  deployment_role_name       = "deployment-role"
  shared_vpc_account_id      = 820149903879
  workload_account_id        = 313676410150
  active_direct_account_id   = 700479275761
  active_directory_tcp_ports = ["53", "3269", "3268", "389", "636", "135", "139", "445"]
  active_directory_udp_ports = ["53", "137", "138", "389"]
}