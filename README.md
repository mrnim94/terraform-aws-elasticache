# terraform-aws-elasticache
# You can refer to this module to provisioning Redis and enable Global Datastore for Elasticache.

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

# resource "aws_elasticache_subnet_group" "redis" {
#   name       = "subnet-group-redis"
#   subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
# }
# Format of private_subnets
# private_subnets = [
#   "subnet-051bfca62cf56dd6c",
#   "subnet-01b8402ea9961ff1c",
# ]

module "elasticache" {
  source  = "mrnim94/elasticache/aws"
  version = "1.2.2"

  aws_region = var.aws_region
  business_divsion = "nimtechnology"
  environment = "dev"
  num_nodes = "2"
  engine_version = "5.0.6"
  family = "redis5.0"
  instance_type = "cache.t2.micro"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  # Pay attention below the line.
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
  version = "1.2.2"

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

## Case 3: If you want to enable the global datastore for Elasticache and create the primary Redis, I will need add `global_datastore = true`

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
  version = "1.2.2"

  aws_region = var.aws_region
  business_divsion = "nimtechnology"
  environment = "dev"
  num_nodes = "2"
  elasticache_subnet_group_name = data.terraform_remote_state.vpc.outputs.elasticache_subnet_group_name
  engine_version = "5.0.6"
  family = "redis5.0"
  instance_type = "cache.m5.large"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  global_datastore = true #Pay attention to this
}
```

## Case 4: Create ElastiCache with `cluster_mode = "enabled"`

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
  version = "1.2.2"

  aws_region = var.aws_region
  business_divsion = "nimtechnology"
  environment = "dev"
  num_nodes = "2"
  elasticache_subnet_group_name = data.terraform_remote_state.vpc.outputs.elasticache_subnet_group_name
  engine_version = "5.0.6"
  family = "redis5.0"
  instance_type = "cache.m5.large"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  cluster_mode = "enabled" # Enable ElastiCache cluster mode

  parameters = [
    {
      name  = "cluster-enabled" # This parameter value must be `yes`
      value = "yes"
    },
    {
      name  = "notify-keyspace-events"
      value = "KEA"
    }
  ]
}
```