output "vpc_network_id" {
  value = module.network.network_id
}

output "subnet_id" {
  value = module.subnet.subnet_id
}

output "service_account_email" {
  value = module.iam.email
}

output "load_balancer_ip" {
  value = module.loadbalancer.load_balancer_ip
}

output "artifact_registry_url" {
  value = module.registry.repo_url
}