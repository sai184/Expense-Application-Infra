module "vpc" {
  source = "./modules/vpc"
  vpc_cidr      = var.vpc_cidr
  env = var.env
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs = var.azs
  default_vpc_id = var.default_vpc_id
  default_vpc_id_cidr = var.default_vpc_id_cidr
  default_route_table_id = var.default_route_table_id
  account_id = var.account_id
}

 module "public-lb" {
  source            = "./modules/alb"

  env               = var.env
  internal          = false
  subnets           = module.vpc.public_subnets
  vpc_id            = module.vpc.vpc_id
    }

