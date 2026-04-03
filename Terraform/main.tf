module "network" {
  source       = "./modules/network"
  network_name = var.network_name
  subnet_name  = var.subnet_name
  cidr         = var.cidr
  region       = var.region
  project_id   = var.project_id
}

module "compute" {
  source = "./modules/compute"


  machine-name    = var.machine-name  
  zone            = var.zone
  subnet_id       = module.subnet.subnet_id
  machine_type    = var.machine_type
  service_account = module.iam.email
}

module "iam" {
  source       = "./modules/iam"
  account_id   = var.account_id
  display_name = "App Service Account"
  project_id   = var.project_id
}

module "firewall" {
  source     = "./modules/firewall"
  network_id = module.network.network_id
  
}

module "registry" {
  source    = "./modules/artifact_registry"
  region    = var.region
  repo_name = var.repo_name
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  instance_group       = module.compute.instance_group
  health_check_name    = var.health_check_name
  backend_name         = var.backend_name
  url_map_name         = var.url_map_name
  proxy_name           = var.proxy_name
  forwarding_rule_name = var.forwarding_rule_name
}

module "subnet" {
  source = "./modules/subnet"

  subnet_name = var.subnet_name
  region      = var.region
  cidr        = var.cidr
  network_id  = module.network.network_id
}