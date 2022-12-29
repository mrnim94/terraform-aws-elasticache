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
# Format of private_subnets
# private_subnets = [
#   "subnet-051bfca62cf56dd6c",
#   "subnet-01b8402ea9961ff1c",
# ]

module "elasticache" {
  source  = "mrnim94/elasticache/aws"
  version = "1.0.4"

  aws_region = var.aws_region
  business_divsion = "nimtechnology"
  environment = "dev"
  num_nodes = "2"
  engine_version = "5.0.6"
  family = "redis5.0"
  instance_type = "cache.t2.micro"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  create_elasticache_subnet_group = true
}
```


## Case 2: Get elasticache subnets from VPC Module

I have used VPC Module and also created elasticache_subnets via VPC Module.
So we don't need to create aws_elasticache_subnet_group. 

```hcl
# Terraform Remote State Datasource - Remote Backend AWS S3
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-on-aws-eks-nim"
    key    = "dev/vpc-redis-2/terraform.tfstate"
    region = var.aws_region
  }
}

module "elasticache" {
  source  = "mrnim94/elasticache/aws"
  version = "1.0.1"

  aws_region = var.aws_region
  business_divsion = "nimtechnology"
  environment = "dev"
  num_nodes = "2"
  elasticache_subnet_group_name = data.terraform_remote_state.vpc.outputs.elasticache_subnet_group_name
  engine_version = "5.0.6"
  family = "redis5.0"
  instance_type = "cache.t2.micro"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}
```

I have a post to explain much knowledge about Redis or Elasticache.

[![Image](https://nimtechnology.com/wp-content/uploads/2022/12/image-174.png "[ElastiCache] Provisioning Redis on AWS so quickly by terraform. ")](https://nimtechnology.com/2022/12/29/elasticache-provisioning-redis-on-aws-so-quickly-by-terraform/)