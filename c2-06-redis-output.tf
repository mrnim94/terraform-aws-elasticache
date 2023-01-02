# https://stackoverflow.com/questions/56257169/terraform-how-to-use-conditionally-created-resources-output-in-conditional-op
output "global_replication_group_id" {
  value = length(aws_elasticache_global_replication_group.global_datastore) > 0 ? aws_elasticache_global_replication_group.global_datastore[0].id : null
  description = "The suffix name of a Global Datastore"
}