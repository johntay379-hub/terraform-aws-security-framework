data "aws_caller_identity" "current" {}

module "iam" {
  source  = "./modules/iam"
  project = var.project
}

module "s3" {
  source     = "./modules/s3"
  project    = var.project
  region     = var.region
  account_id = data.aws_caller_identity.current.account_id
}

module "cloudtrail" {
  source      = "./modules/cloudtrail"
  project     = var.project
  bucket_name = module.s3.bucket_name
  account_id  = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source              = "./modules/vpc"
  project             = var.project
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  region              = var.region
}

module "ec2" {
  source               = "./modules/ec2"
  project              = var.project
  public_subnet_id     = module.vpc.public_subnet_id
  web_sg_id            = module.vpc.web_sg_id
  iam_instance_profile = module.iam.instance_profile_name
  region               = var.region
}

module "cloudwatch" {
  source      = "./modules/cloudwatch"
  project     = var.project
  instance_id = module.ec2.instance_id
  alert_email = var.alert_email
  region      = var.region
}
