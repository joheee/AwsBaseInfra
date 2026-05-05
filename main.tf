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

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr_block = "10.1.0.0/16"
    vpc_name = "base-infra-vpc"
}