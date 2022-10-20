# -------------------------------------------------------------------------------------------------------------
#   CHILD'S MODULE
# --------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">=1.1.5"

  backend "s3" {
    bucket         = "zaynembi1312"
    dynamodb_table = "terraform-lock" # state locking(prevent 2 team members from writing into ststfile thesame time) # LockID
    key            = "path/env"
    region         = "us-east-1"
    encrypt        = "true"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

