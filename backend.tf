terraform {
  backend "s3" {
    bucket = "eduardothums-girus-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
