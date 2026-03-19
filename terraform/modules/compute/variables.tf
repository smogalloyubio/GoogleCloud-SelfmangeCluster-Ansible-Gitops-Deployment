variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "zone" {
  description = "The zone for the cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "service_account_id" {
  description = "Service account ID"
  type        = string
  default     = "gke-service-account"
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-medium"
}