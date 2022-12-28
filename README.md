# terraform-aws-elasticache

## Case 1: Get VPC ID and Subnet Private for Remote State  then Create elasticache subnet group

```hcl
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}

# Terraform Remote State Datasource - Remote Backend AWS S3
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-on-aws-eks-nim"
    key    = "dev/vpc-redis/terraform.tfstate"
    region = var.aws_region
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "subnet-group-redis"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
}

module "elasticache" {
  source  = "mrnim94/elasticache/aws"
  version = "0.0.5"

  aws_region = var.aws_region
  business_divsion = "nimtechnology"
  environment = "dev"
  desired_clusters = "2"
  elasticache_subnet_group_name = aws_elasticache_subnet_group.redis.name
  engine_version = "5.0.6"
  family = "redis5.0"
  instance_type = "cache.t2.micro"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}
```
