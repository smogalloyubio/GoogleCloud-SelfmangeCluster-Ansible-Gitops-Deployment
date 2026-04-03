
resource "google_compute_health_check" "http_health_check" {
  name = var.health_check_name

  http_health_check {
    port = var.app_port
  }
}


resource "google_compute_backend_service" "backend" {
  name     = var.backend_name
  protocol = "HTTP"

  backend {
    group = var.instance_group
  }

  health_checks = [google_compute_health_check.http_health_check.id]
}


resource "google_compute_url_map" "url_map" {
  name            = var.url_map_name
  default_service = google_compute_backend_service.backend.id
}


resource "google_compute_target_http_proxy" "http_proxy" {
  name    = var.proxy_name
  url_map = google_compute_url_map.url_map.id
}


resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = var.forwarding_rule_name
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = var.port_range
}