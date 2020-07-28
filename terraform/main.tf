module "networking" {
  source            = "./modules/networking"
  your_home_network_cidr = var.your_home_network_cidr
  vpc_cidr          = var.vpc_cidr
}

module "ecs" {
  source             = "./modules/ecs"
  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  subnet_private_ids = module.networking.subnet_private_ids
}

module "rds" {
  source             = "./modules/rds-serverless"
  vpc_id             = module.networking.vpc_id
  subnet_private_ids = module.networking.subnet_private_ids
}
