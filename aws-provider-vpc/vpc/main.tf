terraform {
  required_providers {
    aws = {
      version               = "~> 6.0"
      source                = "hashicorp/aws"
      configuration_aliases = [aws.provider_1, aws.provider_2]
    }
  }
}
