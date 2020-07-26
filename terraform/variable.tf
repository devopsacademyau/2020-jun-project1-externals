
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

variable "yourhomenetworkip" {
  type        = string
  description = "Your Home network IP address Range X.X.X.X/32"
}
