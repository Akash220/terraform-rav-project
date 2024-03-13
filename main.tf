terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.39.1"
    }
  }
  backend "s3" {
    bucket = "terra-bucket-96"
    key = "tamilcloud/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my-ec2" {
    ami = "ami-0f403e3180720dd7e"
    instance_type = "t2.micro"
}



