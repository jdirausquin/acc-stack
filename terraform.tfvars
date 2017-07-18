# terraform.tfvars
terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket  = "jdir-devops"
      region  = "us-east-1"
      key     = "acc-stack.tfstate"
      encrypt = true

      # Tell Terraform to do locking using DynamoDB. Terragrunt will automatically
      # create this table for you if it doesn't already exist.
      lock_table = "terragrunt_locks"
    }
  }
}
