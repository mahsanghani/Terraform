# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  access_key = "AKIAI2VRZXJPEB3GJP5Q"
  secret_key = "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"
}

resource "aws_instance" "demo" {
  ami           = "ami-0bcc094591f354be2"
  instance_type = "t3.micro"

  tags = {
    Name = "demo"
  }
}