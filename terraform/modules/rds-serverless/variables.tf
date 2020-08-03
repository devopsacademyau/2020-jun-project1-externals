variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_private_ids" {
  type        = list(string)
  description = "Private Subnet ids"
}

variable "allowed_security_groups" {
  type = list(string)
}

variable "sg_ecs" {
  type = string
}