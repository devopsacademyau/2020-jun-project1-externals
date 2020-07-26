variable "your_home_network_cidr" {
  type        = string
  description = "CIDR for your home network (to allow SSH)"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}
