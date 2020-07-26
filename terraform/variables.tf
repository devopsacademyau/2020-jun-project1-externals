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

variable "yourhomenetworkip" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-2"
}