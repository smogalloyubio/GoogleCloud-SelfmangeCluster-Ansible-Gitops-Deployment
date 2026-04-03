

output "instance_group" {
  description = "The link to the instance group for the Load Balancer"
  value       = google_compute_instance_group_manager.app_mig.instance_group
}

output "instance_template_id" {
  description = "The ID of the instance template used"
  value       = google_compute_instance_template.app_template.id
}