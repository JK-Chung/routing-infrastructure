terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.8"
      configuration_aliases = [aws.networking-infrastructure]
    }
  }

  # set TF CLI version
  required_version = "~> 1.1"

  # use Terraform Cloud as state backend
  cloud {
    organization = "jkc-projects"
    workspaces {
      tags = ["routing-infrastructure"]
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  alias  = "networking-infrastructure"
  region = "eu-west-1"


  default_tags {
    tags = local.default_tags
  }
}