terraform {
  backend "s3" {
    bucket = "terraformeks2025"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
