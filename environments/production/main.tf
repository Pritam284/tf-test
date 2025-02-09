module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr        = "172.16.0.0/16"
  public_subnets  = ["172.16.10.0/24", "172.16.20.0/24"]
  private_subnets = ["172.16.30.0/24", "172.16.40.0/24"]
  tags = {
    "Name" = "Production-test-vpc"
  }
}