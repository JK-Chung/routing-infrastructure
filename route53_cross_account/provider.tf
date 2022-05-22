terraform {
  required_providers {
    aws = {
      source                               = "hashicorp/aws"
      version                              = "~> 4.8"
      configuration_aconfiguration_aliases = [aws.networking_infrastructure]
    }
  }
}

provider "aws" {

}