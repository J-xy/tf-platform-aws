# org/versions.tf
terraform {
  required_version = "~> 1.11" # use_lockfile needs 1.11+; < 2.0 guards against the next major
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # org/ was created on 6.x; the other stacks are still on 5.x
    }
  }
}