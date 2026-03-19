variable "region" {
  description = "The region for the network resources"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "vpc-network"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet"
}

variable "ip_cidr_range" {
  description = "IP CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "pods_ip_cidr_range" {
  description = "IP CIDR range for pods"
  type        = string
  default     = "10.1.0.0/16"
}

variable "services_ip_cidr_range" {
  description = "IP CIDR range for services"
  type        = string
  default     = "10.2.0.0/16"
}

variable "enable_ipv6" {
  description = "Enable IPv6 for the VPC"
  type        = bool
  default     = false
}

variable "allowed_ssh_ips" {
  description = "List of IP ranges allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict in production
}