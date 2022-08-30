terraform {
  required_providers {
    aws = {
      version = ">= 4.0.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias  = "source"
  region = var.source_region
}

provider "aws" {
  alias  = "destination"
  region = var.destination_region
}
