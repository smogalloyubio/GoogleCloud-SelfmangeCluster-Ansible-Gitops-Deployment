variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
  type        = string
}

variable "zone" {
  description = "The zone to host the cluster in"
  default     = "us-central1-c"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  default     = "prod-gke-cluster"
  type        = string
}

variable "machine_type" {
  description = "Machine type for nodes"
  default     = "e2-medium"
  type        = string
}