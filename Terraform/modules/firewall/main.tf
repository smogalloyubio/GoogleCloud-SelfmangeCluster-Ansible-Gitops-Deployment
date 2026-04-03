resource "google_compute_firewall" "googel-firewall" {
  name    = "test-firewall"
  network = var.network_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

 source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "googel-firewall-app" {
  name    = "test-app"
 network = var.network_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

 source_ranges = ["0.0.0.0/0"]
}