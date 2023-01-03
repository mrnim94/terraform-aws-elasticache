resource "aws_elasticache_global_replication_group" "global_datastore" {
  count = var.global_datastore ? 1 : 0

  global_replication_group_id_suffix = lower(local.name)
  primary_replication_group_id       = aws_elasticache_replication_group.redis.id
}