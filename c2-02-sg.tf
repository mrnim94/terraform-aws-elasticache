#
# Security group resources
#
resource "aws_security_group" "redis" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #https://stackoverflow.com/questions/43980946/define-tags-in-central-section-in-terraform
  tags = merge(
    local.common_tags,
    tomap({
      "Name"      = "sgCacheCluster" ##look into
    })
  )

  # the "map" function was deprecated in Terraform v0.12
  # tags = merge(
  #   local.common_tags,
  #   map(
  #     "Name", "sgCacheCluster",
  #     "Project", var.project,
  #   )
  # )

  lifecycle {
      create_before_destroy = true
  } 

}