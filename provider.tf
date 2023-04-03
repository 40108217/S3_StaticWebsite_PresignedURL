terraform {

required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
      
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.2"
  
}
/*
provider "aws" {
  profile = "aclg"
}
*/
provider "aws" {

  #shared_credentials_files = "/Users/jaspalkaur/.aws/credentials"
  profile = "aclg" # you may change to desired profile
  region = "us-east-1"
}



