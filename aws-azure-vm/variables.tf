variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "sa-east-1"
}

variable "azure_region" {
  type        = string
  description = "Azure region"
  default     = "brazilsouth"
}

variable "aws_key_pub" {
  type        = string
  description = "AWS public key"
}

variable "azure_key_pub" {
  type        = string
  description = "Azure public key"
}