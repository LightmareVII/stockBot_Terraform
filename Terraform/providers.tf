terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}

provider "aws" {
  region     = var.creds.region
  access_key = var.creds.access
  secret_key = var.creds.secret
}