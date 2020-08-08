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


variable "subnet_public_ids" {
  type        = list(string)
  description = "public Subnet ids"
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

variable "wpalb_sg_id" {
  description = "Application Load Balancer Security Group"
}

variable "ecs_sg_id" {
  description = "ECS Security Group"
}

variable "security_groups_ids" {
  type        = list(string)
  description = "Security group lists"
}

variable "alb_port" {
  description = "ALB listener port"
}

variable "container_port" {
  description = "ALB target port"
}

variable "desired_tasks" {
  description = "Number of containers desired to run the application task"
}

variable "desired_task_cpu" {
  description = "Task CPU Limit"
}

variable "desired_task_memory" {
  description = "Task Memory Limit"
}

variable "min_tasks" {
  description = "Minimum"
}

variable "max_tasks" {
  description = "Maximum"
}

variable "cpu_to_scale_up" {
  description = "CPU % to Scale Up the number of containers"
}

variable "cpu_to_scale_down" {
  description = "CPU % to Scale Down the number of containers"
}

variable  "alb_certificate_arn" {
  description = "Enter your certificate arn from ACM"
  type        = string
}

variable "dns_name" {
  description = "Enter your Route 53 Zone record"
}

variable "zone_id" {
  description = "Enter your zone ID "
}

variable "image_tag" {
  description = "ecr docker image tag "
}