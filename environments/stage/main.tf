module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr        = "10.10.0.0/16"
  public_subnets  = ["10.10.10.0/24", "10.10.20.0/24"]
  private_subnets = ["10.10.30.0/24", "10.10.40.0/24"]
  tags = {
    "Name" = "Stage-test-vpc"
  }
}