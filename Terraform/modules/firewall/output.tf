output "firewall_names" {
  value = [
    google_compute_firewall.googel-firewall.name,
    google_compute_firewall.googel-firewall-app.name
  ]
}