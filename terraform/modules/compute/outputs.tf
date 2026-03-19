output "cluster_name" {
  description = "GKE Cluster Name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "GKE Cluster Endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  description = "GKE Cluster CA Certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${google_container_cluster.primary.location} --project ${var.project_id}"
}

output "cluster_location" {
  description = "GKE Cluster Location (Zone)"
  value       = google_container_cluster.primary.location
}

output "cluster_self_link" {
  description = "Self-link of the GKE cluster"
  value       = google_container_cluster.primary.self_link
}

output "cluster_master_version" {
  description = "Kubernetes master version"
  value       = google_container_cluster.primary.master_version
}

output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.default.email
}

output "node_pool_name" {
  description = "Name of the node pool"
  value       = google_container_node_pool.primary_nodes.name
}

output "node_pool_instance_group_urls" {
  description = "Instance group URLs of the node pool"
  value       = google_container_node_pool.primary_nodes.instance_group_urls
}

output "workload_identity_pool" {
  description = "Workload Identity pool"
  value       = google_container_cluster.primary.workload_identity_config[0].workload_pool
}