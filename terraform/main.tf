module "networking" {
  source            = "./modules/networking"
  yourhomenetworkip = var.yourhomenetworkip
  vpc_cidr          = var.vpc_cidr
}
