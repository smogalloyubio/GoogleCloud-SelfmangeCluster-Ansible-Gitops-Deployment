variable "instance_group" {
  description = "Instance group managed by compute module"
  type        = string
}

variable "health_check_name" {
  type = string
}

variable "backend_name" {
  type = string
}

variable "url_map_name" {
  type = string
}

variable "proxy_name" {
  type = string
}

variable "forwarding_rule_name" {
  type = string
}

variable "port_range" {
  description = "External port (usually 80)"
  type        = string
  default     = "80"
}

variable "app_port" {
  description = "Port your app runs on inside VM (e.g. 8080)"
  type        = number
  default     = 8080
}