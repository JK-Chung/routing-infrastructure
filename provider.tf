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
    organization = "jkc-projects"
    workspaces {
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      project    = "all_projects"
      managed_by = "terraform"
      github_org = "shared-infrastructure"
      repo       = "routing-infrastructure"
    }
  }
}