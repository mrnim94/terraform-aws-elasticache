resource "aws_sns_topic" "redis" {
  name = lower(local.redis_cluster_name)
  
}

# #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group
resource "aws_elasticache_parameter_group" "redis" {
  name   = "cache-params-${lower(local.redis_cluster_name)}"
  family = var.family

  parameter {
    name  = "activerehashing"
    value = "yes"
  }
  parameter {
    name  = "notify-keyspace-events"
    value = "KEA"
  }
}

#https://medium.com/swlh/terraform-how-to-use-conditionals-for-dynamic-resources-creation-6a191e041857
resource "aws_elasticache_subnet_group" "redis" {
  count = var.create_elasticache_subnet_group ? 1 : 0
  name       = "subnet-group-${lower(local.redis_cluster_name)}"
  subnet_ids = var.private_subnets
}

# #
# # ElastiCache resources
# #
resource "aws_elasticache_replication_group" "redis" {
  depends_on = [aws_elasticache_parameter_group.redis ]

  replication_group_id          = lower(local.redis_cluster_name)
  description = "${var.environment}-redis"
  automatic_failover_enabled    = var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled
  #availability_zones            =  var.availability_zones == [] ? null : var.availability_zones
#   preferred_cache_cluster_azs  = module.vpc.azs

  num_cache_clusters         = var.num_nodes
  node_type                     = var.instance_type
  engine_version                = var.engine_version
  parameter_group_name          = aws_elasticache_parameter_group.redis.name
  subnet_group_name             = "${var.create_elasticache_subnet_group ? aws_elasticache_subnet_group.redis[0].name : var.elasticache_subnet_group_name}"
  security_group_ids            = [aws_security_group.redis.id]
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = aws_sns_topic.redis.arn
  port                          = "6379"

  # cluster_mode {
  #   replicas_per_node_group = 1
  #   num_node_groups         = 2
  # }

  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled

  tags = merge(
    local.common_tags,
    tomap({
      "Name"    = "CacheReplicationGroup"
    })
  )
}

#
# CloudWatch resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count = var.num_nodes

  alarm_name          = "alarm${var.environment}CacheCluster00${count.index + 1}CPUUtilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }

  alarm_actions = [aws_sns_topic.redis.arn]

}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count = var.num_nodes

  alarm_name          = "alarm${var.environment}CacheCluster00${count.index + 1}FreeableMemory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = var.alarm_memory_threshold

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }

  alarm_actions = [aws_sns_topic.redis.arn]

}