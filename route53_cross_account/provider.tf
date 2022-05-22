terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.8"
      configuration_aliases = [aws.networking_infrastructure]
    }
  }
}

provider "aws" {
  alias = "aws"
}