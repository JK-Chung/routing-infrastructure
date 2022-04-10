terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8"
    }
  }

  # set TF CLI version
  required_version = "~> 1.1"

  # use Terraform Cloud as state backend
  cloud {
    organization = "shared-infrastructure"
    workspaces {
      name = "routing-infrastructure"
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    application = "all_projects"
    managed_by  = "terraform"
    repo        = "routing-infrastructure"
  }
}