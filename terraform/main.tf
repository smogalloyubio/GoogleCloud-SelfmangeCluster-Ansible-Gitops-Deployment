module "network" {
  source = "./modules/network"

  region = var.region
}

module "compute" {
  source = "./modules/compute"

  project_id   = var.project_id
  zone         = var.zone
  cluster_name = var.cluster_name
  vpc_name     = module.network.vpc_name
  subnet_name  = module.network.subnet_name
  machine_type = var.machine_type
}