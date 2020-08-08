variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "2020-jun-project1-externals"
}

variable "your_home_network_cidr" {
  type        = string
  description = "Your home network CIDR"
}


variable "cpu_to_scale_up" {
  description = "CPU % to Scale Up the number of containers"
  default     = 80
}

variable "cpu_to_scale_down" {
  description = "CPU % to Scale Down the number of containers"
  default     = 30
}

# Desired CPU
variable "desired_task_cpu" {
  description = "Desired CPU to run your tasks"
  default     = "256"
}

# Desired Memory
variable "desired_task_memory" {
  description = "Desired memory to run your tasks"
  default     = "512"
}

# Listener Application Load Balancer Port
variable "alb_port" {
  description = "Origin Application Load Balancer Port"
  default     = "443"
}

# Target Group Load Balancer Port
variable "container_port" {
  description = "Destination Application Load Balancer Port"
  default     = "80"
}

variable "min_tasks" {
  description = "Minimum"
  default     = 2
}

variable "max_tasks" {
  description = "Maximum"
  default     = 4
}

variable "desired_tasks" {
  description = "Number of containers desired to run app task"
  default     = 2
}

variable "alb_certificate_arn" {
  description = "Enter your certificate arn from ACM"
  type        = string
}

variable "dns_name" {
  description = "Enter your Route 53 Zone record name. Ex. prod, dev"
  type        = string
}

variable "zone_id" {
  description = "Enter your zone ID "
  type        = string
}

variable "image_tag" {
  description = "Docker Image Tag "
  type        = string
  default = "latest"
}