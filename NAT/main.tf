# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  access_key = "hide"
  secret_key = "hide"
}

resource "aws_instance" "demo" {
  ami           = "ami-0bcc094591f354be2"
  instance_type = "t3.micro"

  tags = {
    Name = "demo"
  }
}