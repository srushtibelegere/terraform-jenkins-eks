terraform {
  backend "s3" {
    bucket = "terraformeks2025"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}
