# Terraform settings block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 5.0"
      # Uncomment the version line for production-level use
    }
    null = {
      source = "hashicorp/null"
    }
    
  }
  # backend "s3" {
  #     bucket = "terraform1111statesfiles"
  #     key = "terraform.tfstate"
  #     region = "us-east-1"
  #     #dynamodb_table = ""
  #   }
}

# Provider block
provider "aws" {
  region = var.aws_region
}