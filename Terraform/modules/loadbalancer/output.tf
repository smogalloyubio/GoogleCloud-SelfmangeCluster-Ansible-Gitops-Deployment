output "load_balancer_ip" {
  description = "Public IP of the load balancer"
  value       = google_compute_global_forwarding_rule.forwarding_rule.ip_address
}

output "backend_service_name" {
  value = google_compute_backend_service.backend.name
}