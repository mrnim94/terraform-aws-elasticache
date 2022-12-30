output "global_replication_group_id" {
  description = "The suffix name of a Global Datastore"
  value       = lower(local.name)
}