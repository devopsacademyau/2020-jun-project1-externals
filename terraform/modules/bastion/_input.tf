variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ssh_allowed_cidrs" {
  type = list(string)
}

variable "project_name" {
  type        = string
  description = "Project Name"
}