terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.8"
        }
    }

    # set TF CLI version
    required_version = "~> 1.1"
}

provider "aws" {
    profile = "default"
    region = "eu-west-1"
}

