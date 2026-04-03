resource "google_compute_subnetwork" "subnet-network" {
  name          =var.subnet_name
  ip_cidr_range = var.cidr
  region        = var.region
  network       = var.network_id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}