output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "vpc_self_link" {
  description = "Self-link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "subnet_self_link" {
  description = "Self-link of the subnet"
  value       = google_compute_subnetwork.subnet.self_link
}

output "vpc_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_gateway_address" {
  description = "Gateway address of the subnet"
  value       = google_compute_subnetwork.subnet.gateway_address
}

output "pods_secondary_range_name" {
  description = "Name of the pods secondary IP range"
  value       = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
}

output "services_secondary_range_name" {
  description = "Name of the services secondary IP range"
  value       = google_compute_subnetwork.subnet.secondary_ip_range[1].range_name
}