


resource "google_service_account" "default" {
  account_id   = var.service_account_id
  display_name = "GKE Service Account"
}

# Standard GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1  

  network    = var.vpc_name
  subnetwork = var.subnet_name

  # Enable workload identity (optional, keep for Vault integration)
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }
}


resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.zone
  node_count = 2

  node_config {
    machine_type    = var.machine_type
    preemptible     = false
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}