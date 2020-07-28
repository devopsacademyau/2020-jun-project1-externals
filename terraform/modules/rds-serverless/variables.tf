
variable "db_name" {
  type = string
  default = "aurora-serverless"
}

variable "db_name" {
  type = string
  default = "aurora-serverless"
}

variable "db_engine" {
  type = string
  default = "aurora"
}

variable "engine_mode" {
  type = string
  default = "serverless"
}

variable "replica_scale_enabled" {
  type    = bool
  default = false
}

variable "replica_count" {
  type    = number
  default = 0
}

variable "backtrack_window" {
  type    = number
  default = 10
}

variable "monitoring_interval" {
  type    = number
  default = 60
}

variable "db_instance_type" {
  default = "db.t2.small"
}


variable "backup_retention_period" {
  type    = number
  default = 1
}

variable "apply_immediately" {
  type    = bool
  default = true
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "storage_encrypted" {
  type    = bool
  default = true
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}
