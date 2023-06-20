terraform {
  backend "s3" {
    bucket = "siva-aws-infrastructure-tfstate"
    key    = "stage/terraform.tfstate"
    region = "ap-south-1"
  }
}