terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.51.0"
        }
    }

    backend "s3" {
    bucket = "execute-tech-terraform-state"
    key = "execute-tech/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
    use_lockfile = true

    }

}
provider "aws" {
    region = var.aws_region
}

