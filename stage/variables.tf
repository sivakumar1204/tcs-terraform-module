variable "env" {
  type    = string
  default = "stage"
}

variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
  type        = string
}


variable "frontend_instance_type" {
  type    = string
  default = "t2.large"
}


variable "backend_instance_type" {
  type    = string
  default = "t2.large"
}

variable "ssh_key_pair" {
  type    = string
  default = "siva-devops-terraform-sfjbs" //created manually from console 
}

variable "volume_size" {
  type    = any
  default = 20
}

variable "ssh_allowed_ips" {
  type    = string
  default = "0.0.0.0/0"
}

variable "cidr" {
  type    = string
  default = "10.2.0.0/16" //if you want to change than change accordingly
}

variable "private_subnets" {
  type    = list(any)
  default = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"] //if you want to change than change accordingly
}

variable "public_subnets" {
  type    = list(any)
  default = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"] //if you want to change than change accordingly
}