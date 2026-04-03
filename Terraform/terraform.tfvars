project_id = "ubioworo-project"
region     = "us-central1"
zone       = "us-central1-a"

network_name = "app-vpc"
subnet_name  = "app-subnet"
cidr         = "10.10.0.0/24"

account_id = "service-account-app"

repo_name = "googla-app-deploy"

machine-name = "my-docker-machine"

machine_type = "e2-medium"

docker_image = "europe-west1-docker.pkg.dev/my-gcp-project/app-repo/app:latest"

health_check_name    = "http-health"
backend_name         = "backend-service"
url_map_name         = "url-map"
proxy_name           = "http-proxy"
forwarding_rule_name = "lb-rule"
