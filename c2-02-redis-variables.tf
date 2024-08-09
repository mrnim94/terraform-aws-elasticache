# Input Variables - Placeholder file
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "SAP"
}

//checked
variable "family" {
  type        = string
  default     = "redis5.0"
  description = "(Required) The family of the ElastiCache parameter group."
}

//checked
variable "automatic_failover_enabled" {
  default     = true
  description = "- (Optional) Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, num_cache_clusters must be greater than 1. Must be enabled for Redis (cluster mode enabled) replication groups."
}

//checked
variable "cluster_mode" {
  type        = string
  default     = "disabled"
  description = "- (Optional) Specifies whether cluster mode is enabled or disabled. Valid values are enabled or disabled or compatible."
}

variable "parameters" {
  description = "A map of configuration parameters for the AWS Elasticache Parameter Group. Each key represents the parameter name, and the corresponding value sets the parameter's configuration."
  type        = map(string)
  default = {
    "cluster-enabled"        = "no"
    "notify-keyspace-events" = "KEA"
  }
}

//checked
variable "apply_immediately" {
  type        = bool
  default     = false
  description = "- (Optional) Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false"
}


//checked
variable "multi_az_enabled" {
  default     = true
  description = "- (Optional) Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic_failover_enabled must also be enabled. Defaults to true."
}

variable "alarm_memory_threshold" {
  # 10MB
  default     = "10000000"
  description = "- (Optional) The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models."
}

variable "alarm_cpu_threshold" {
  default     = "75"
  description = "- (Optional) The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models."
}

//checked
variable "num_nodes" {
  default     = "3"
  description = "- (Optional) Number nodes of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. Conflicts with num_node_groups, the deprecatednumber_cache_clusters, or the deprecated cluster_mode."
}

//checked
variable "instance_type" {
  default     = "cache.t2.micro"
  description = "(Optional) Instance class to be used. See AWS documentation for information on supported node types and guidance on selecting node types. Required unless global_replication_group_id is set. Cannot be set if global_replication_group_id is set."
}

//checked
variable "engine_version" {
  default     = "5.0.6"
  description = "- (Optional) Version number of the cache engine to be used for the cache clusters in this replication group."
}

//checked
variable "maintenance_window" {
  default     = "sun:02:30-sun:03:30"
  description = "– (Optional) Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00."
}

//checked
variable "at_rest_encryption_enabled" {
  type        = bool
  default     = true
  description = "Enable encryption at rest"
}

//checked
variable "transit_encryption_enabled" {
  type        = bool
  default     = true
  description = <<-EOT
    Set `true` to enable encryption in transit. Forced `true` if `var.auth_token` is set.
    If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis.
    EOT
}

variable "elasticache_subnet_group_name" {
  type        = string
  default     = "Unknown"
  description = "- (Optional) Name of the cache subnet group to be used for the replication group."
}

variable "vpc_id" {
  type        = string
  default     = "Unknown"
  description = "- (Required) The ID of the VPC is to create Security Group."
}


variable "create_elasticache_subnet_group" {
  type        = bool
  default     = false
  description = "- (Required) The ID of the VPC is to create Security Group."
}

variable "private_subnets" {
  type        = list(any)
  description = "- (Optional) A list of private subnets inside the VPC."
  default     = []
}

variable "global_datastore" {
  type        = bool
  default     = false
  description = "- (Optional) Provides an ElastiCache Global Replication Group resource, which manages replication between two or more Replication Groups in different regions."
}

