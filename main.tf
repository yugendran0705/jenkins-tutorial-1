terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type    = string
  default = "us-east-1"
}

resource "aws_s3_bucket" "tf_example" {
  bucket = "jenkins-tf-example-bucket-123456" # must be globally unique
  tags = {
    Name        = "jenkins-tf-example"
    Environment = "dev"
  }
}
