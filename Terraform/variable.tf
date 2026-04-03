variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "network_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "cidr" {
  description = "CIDR range for subnet"
  type        = string
}

variable "account_id" {
  description = "Service account ID"
  type        = string
}

variable "repo_name" {
  description = "Artifact Registry repo name"
  type        = string
}

variable "machine-name" {
  description = "VM instance name"
  type        = string
}

variable "machine_type" {
  description = "VM machine type"
  type        = string
  default     = "e2-medium"
}

variable "docker_image" {
  description = "Docker image URL from Artifact Registry"
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


