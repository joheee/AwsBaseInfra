terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
    backend "s3" {
        bucket = "upwork-terraform"
        key = "aws-base-infra/terraform.tfstate"
        region = "ap-southeast-1"
        use_lockfile = true
    }
}

provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
}