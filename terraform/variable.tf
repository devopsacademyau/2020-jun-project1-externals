
variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "yourhomenetworkip" {
  type        = string
  description = "Your Home network IP address Range X.X.X.X/32"
}
