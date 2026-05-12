terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "upwork-terraform"
    key          = "aws-base-infra/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = "10.1.0.0/16"
  vpc_name       = "base-infra-vpc"
}

module "ec2-subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr_block = "10.1.0.0/24"
  subnet_name       = "base-infra-ec2-subnet"
  availability_zone = "${var.region}a"
}

module "cluster-subnet-a" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr_block = "10.1.1.0/24"
  subnet_name       = "base-infra-cluster-subnet-a"
  availability_zone = "${var.region}a"
}

module "cluster-subnet-b" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_cidr_block = "10.1.2.0/24"
  subnet_name       = "base-infra-cluster-subnet-b"
  availability_zone = "${var.region}b"
}

module "ec2-nic" {
  source     = "./modules/nic"
  subnet_id  = module.ec2-subnet.subnet_id
  private_ip = "10.1.0.10"
  nic_name   = "base-infra-nic"
}

module "ec2-instance" {
  source        = "./modules/ec2"
  ami           = "ami-02dd44faa40720bb8"
  instance_type = "t2.micro"
  nic_id        = module.ec2-nic.nic_id
  ec2_name      = "base-infra-ec2"
}

module "iam_role_cluster" {
  source = "./modules/iam_role"
  name = "base-infra-iam-role-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

module "eks_cluster" {
  source = "./modules/eks"
  name = "base-infra-eks-cluster"
  role_arn = module.iam_role_cluster.arn
  authentication_mode = "API"
  subnet_ids = [module.cluster-subnet-a.subnet_id, module.cluster-subnet-b.subnet_id]
}