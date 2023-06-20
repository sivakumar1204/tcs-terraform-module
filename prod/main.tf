locals {
  owner        = "siva"
  module_name  = "${var.env}-${local.owner}" //prod-siva
  ssh_key_pair = "siva-devops-terraform-sfjbs" //key pair created manually
}

module "networking" {
  source          = "C:/Users/sivar/Desktop/KPLabs-Terraform/TCS/tcs-terraform-modules/modules/networking"
  env             = var.env //fetch the values from the prod--->veriables.tf file
  cidr            = var.cidr //fetch the values from the prod--->veriables.tf file
  private_subnets = var.private_subnets //fetch the values from the prod--->veriables.tf file
  public_subnets  = var.public_subnets //fetch the values from the prod--->veriables.tf file
}

module "compute" {
  source                 = "C:/Users/sivar/Desktop/KPLabs-Terraform/TCS/tcs-terraform-modules/modules/compute"
  env                    = var.env //fetch the values from the prod--->veriables.tf file
  vpc                    = module.networking.vpc //fetch the values from the modules networking--->main.tf file
  sg_pub_id              = module.networking.sg_pub_id //fetch the values from the modules networking--->output.tf file
  sg_priv_id             = module.networking.sg_priv_id //fetch the values from the modules networking--->output.tf file
  key_name               = local.ssh_key_pair //fetching the value from above local file
  frontend_instance_type = var.frontend_instance_type //fetch the values from the prod--->veriables.tf file
  backend_instance_type  = var.backend_instance_type //fetch the values from the prod--->veriables.tf file
  volume_size            = var.volume_size //fetch the values from the prod--->veriables.tf file
}

module "security" {
  source = "C:/Users/sivar/Desktop/KPLabs-Terraform/TCS/tcs-terraform-modules/modules/security"

  vpc_id          = module.networking.vpc.vpc_id //fetch the values from the modules networking--->output.tf file
  vpc_cidr_block  = var.cidr //fetch the values from the prod--->veriables.tf file
  ssh_allowed_ips = var.ssh_allowed_ips //fetch the values from the prod--->veriables.tf file
  env             = var.env //fetch the values from the prod--->veriables.tf file
}