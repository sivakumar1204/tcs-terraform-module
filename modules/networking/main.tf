locals {
  owner       = "siva"
  module_name = "${var.env}-${local.owner}" //it will be like stage-siva/prod-siva depands on env variable
}
// TODO break public and private into separate AZs
data "aws_availability_zones" "available" {}

module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws" //using published modules taken from "https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest"
  name                         = "${local.module_name}-vpc" //it will be display as stage-siva-vpc /prod-siva-vpc
  cidr                         = var.cidr
  azs                          = data.aws_availability_zones.available.names
  private_subnets              = var.private_subnets
  public_subnets               = var.public_subnets
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
}

// SG to allow SSH connections from anywhere
resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.env}-allow_ssh" // stage-allow_ssh / prod-allow_ssh
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id // it will crreate the vpc id

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.module_name}-allow_ssh_pub" // stage-siva-allow_ssh_pub / prod-siva-allow_ssh_pub
  }
}

// SG to onlly allow SSH connections from VPC public subnets
resource "aws_security_group" "allow_ssh_priv" {
  name        = "${var.env}-allow_ssh_priv"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH only from internal VPC clients"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16", "10.0.2.74/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.module_name}-allow_ssh_priv" // stage-siva-allow_ssh_priv / prod-siva-allow_ssh_priv
  }
}