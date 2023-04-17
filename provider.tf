provider "digitalocean" {
  token = var.do_token
}
terraform {
    backend "s3" {
        bucket = "kamil-zaborowski"
        key = "terraform/terraform.state"
        region = "fra1"
    }
    required_providers {
        digitalocean = {
           source = "digitalocean/digitalocean"
           version = "~> 2.0"
        }
    }
}