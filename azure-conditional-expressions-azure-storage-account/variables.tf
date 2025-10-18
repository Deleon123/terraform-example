variable "location" {
  description = "Location where the resources will be created on Azure"
  type        = string
  default     = "brazilsouth"

}

variable "environment" {
  type        = string
  description = "value to be used to determine the environment of the resources to be created on Azure"
}