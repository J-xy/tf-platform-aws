# org/backend.tf — same bucket, its own key, so the org stack has its own lock.

terraform {
  backend "s3" {
    bucket       = "tf-state-964291633585-us-east-1"
    key          = "org/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}