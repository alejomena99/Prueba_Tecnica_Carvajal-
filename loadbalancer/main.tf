provider "aws" {}

module "vpc_module" {
  source = "./modules/vpc"

  vpc_cidrs = "10.0.0.0/16"
  name = "alejo"
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  tags = {
    Terraform = "true"
    Environment = "dev"
  }

}

