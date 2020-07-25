module "networking" {
  source            = "./modules/networking"
  yourhomenetworkip = var.yourhomenetworkip
  vpc_cidr          = var.vpc_cidr
}

module "ecs" {
  source            = "./modules/ecs"
  project_name      =  var.project_name
  vpc_id            = module.networking.vpc_id
}