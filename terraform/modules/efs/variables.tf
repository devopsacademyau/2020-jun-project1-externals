variable "subnet_id1" {
  type = string
}

variable "subnet_id2" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "sg_ecs" {
  type = string
}