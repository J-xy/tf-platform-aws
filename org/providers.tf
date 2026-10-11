# org/providers.tf
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner        = "jack"
      project      = "tf-platform-lab"
      stage        = "3-org" # was "2-network"
      "managed-by" = "terraform"
    }
  }
}