variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}