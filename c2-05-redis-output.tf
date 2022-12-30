output "global_replication_group_id" {
  description = "The suffix name of a Global Datastore"
  value       = aws_elasticache_global_replication_group.global_datastore[0].id
}