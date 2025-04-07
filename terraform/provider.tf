provider "aws" {
  region     = "us-east-1"  # Choose your preferred region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
