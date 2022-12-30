output "global_replication_group_id" {
  description = "The suffix name of a Global Datastore"
  value       = aws_elasticache_global_replication_group[0].global_replication_group_id
}