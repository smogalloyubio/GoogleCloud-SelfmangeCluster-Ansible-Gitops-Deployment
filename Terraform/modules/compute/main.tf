resource "google_compute_instance_template" "app_template" {
  name         = "app-template"
  machine_type = "e2-medium"

  tags = ["app"]

 

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {}
  }

  service_account {
    email = var.service_account
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update
    apt install -y docker.io

    
  EOF
}


resource "google_compute_instance_group_manager" "app_mig" {
  name               = "app-mig"
  base_instance_name  = "app"
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.app_template.id
  }

  target_size = 2
}