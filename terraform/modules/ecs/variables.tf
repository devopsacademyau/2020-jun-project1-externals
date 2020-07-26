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
