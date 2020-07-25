# Initialize availability zone data from AWS
data "aws_availability_zones" "available" {}


# VPC resource
resource "aws_vpc" "wp_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "wp_vpc"
  }
}