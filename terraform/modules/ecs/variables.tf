variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_private_ids" {
  type        = list(string)
  description = "Private Subnet ids"
}

variable "cpu" {
  type        = string
  description = "Fargate CPU units (.25 vCPU  = 256 units) "
  default     = "256"
}

variable "memory" {
  type        = string
  description = "Fargate Memory "
  default     = "512"
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "ecs_platform_version" {
  type    = string
  default = "1.4.0"
}

variable "retention_in_days" {
  type    = number
  default = 1
}


variable "file_system_id" {
  type = string
}

variable "rds" {
  type = map
}