resource "aws_s3_bucket" "terraform_backend_bucket" {
      bucket = "terraform-state-gsn8lq9q2tgppvyrm6a57o057uw9z10c6rcod4wpo748l"
}

terraform {
  required_providers {
    aws =  {
    source = "hashicorp/aws"
    version = ">= 2.7.0"
    }
  }
}

provider "aws" {
    region = "us-west-2"
}

