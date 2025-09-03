# Get current public IP address dynamically
data "http" "current_ip" {
  url = "https://api.ipify.org"
}

locals {
  my_ip = "${chomp(data.http.current_ip.response_body)}/32"
  allowed_ips = concat([local.my_ip], var.allowed_ips)
}