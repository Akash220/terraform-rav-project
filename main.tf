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

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "my-igw" {}

resource "aws_internet_gateway_attachment" "igw-attachement"{
  internet_gateway_id = aws_internet_gateway.my-igw.id
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_subnet" "public-subnet1" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone  = "us-east-1a"
}

resource "aws_subnet" "public-subnet2" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private-subnet1" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"  
}

resource "aws_subnet" "private-subnet2" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"  
}

resource "aws_route_table" "public-routetable" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "public-rt1-association" {
  route_table_id = aws_route_table.public-routetable.id
  subnet_id = aws_subnet.public-subnet1.id
}

resource "aws_route_table_association" "public-rt2-association" {
  route_table_id = aws_route_table.public-routetable.id
  subnet_id = aws_subnet.public-subnet2.id
}

resource "aws_security_group" "BastionSecurityGroup" {
  description = "Bastion Security Group"
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_security_group_rule" "allow-http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.BastionSecurityGroup.id
}

resource "aws_security_group_rule" "allow-rdp" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = aws_security_group.BastionSecurityGroup.id
}

resource "aws_security_group_rule" "allow-ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.BastionSecurityGroup.id
}

resource "aws_instance" "bastion-instance"{
  ami = "ami-0e731c8a588258d0d"
  instance_type = "t2.medium"
  key_name = "testing-ec2-rds"
  subnet_id = aws_subnet.public-subnet1.id
  security_groups = ["BastionSecurityGroup"]
  user_data = "yum install mysql"
}











