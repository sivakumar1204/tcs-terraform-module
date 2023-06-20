terraform {
  backend "s3" {
    bucket = "siva-aws-infrastructure-tfstate"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
  }
}