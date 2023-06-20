locals {
  owner        = "siva"
  module_name  = "${var.env}-${local.owner}"   //it will be display as stage-siva
  ssh_key_pair = "siva-devops-terraform-sfjbs" //created manually from conole and used here
}

module "networking" {
  source          = "C:/Users/sivar/Desktop/KPLabs-Terraform/TCS/tcs-terraform-modules/modules/networking"
  env             = var.env
  cidr            = var.cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "compute" {
  source     = "C:/Users/sivar/Desktop/KPLabs-Terraform/TCS/tcs-terraform-modules/modules/compute"
  env        = var.env
  vpc        = module.networking.vpc        //metioned vpc is the output variable which are fetching from networking output.tf file
  sg_pub_id  = module.networking.sg_pub_id  //metioned sg_pub_id is the output variable which are fetching from networking output.tf file
  sg_priv_id = module.networking.sg_priv_id //metioned sg_priv_id is the output variable which are fetching from networking output.tf file
  key_name   = local.ssh_key_pair
  frontend_instance_type = var.frontend_instance_type //those value are fetcing frmo stage env input variables.tf file
  backend_instance_type = var.backend_instance_type //those value are fetcing frmo stage env input variables.tf file
  volume_size           = var.volume_size           //those value are fetcing frmo stage env input variables.tf file
}

module "security" {
  source = "C:/Users/sivar/Desktop/KPLabs-Terraform/TCS/tcs-terraform-modules/modules/security"

  vpc_id          = module.networking.vpc.vpc_id
  vpc_cidr_block  = var.cidr
  ssh_allowed_ips = var.ssh_allowed_ips
  env             = var.env
}