variable "aws_region" {
    default = "us-east-1"
}

variable "cidr_block" {
    description = "cidr block for vpc"
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_count" {
    description = "Number of subnets"
    type = map(any)
    default = {
        public = 1,
        private = 2
    }
}

variable "settings" {
    description = "configuration settings"
    type = map(any)
    default = {
        "database" = {
            allocated_storage = 10
            engine = "mysql"
            engine_version = "8.0.27"
            instance_class = "db.t2.micro"
            db_name = "testDB"
        },
        "web_app" = {
            count = 1
            instance_type = "t2.micro"
        }
    }
}

variable "public_subnet_cidr_blocks"{
    description = "available cidr blocks for public subnet"
    type = list(string)
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24",
        "10.0.4.0/24"
    ]
}

variable "private_subnet_cidr_blocks" {
    description = "available cidr blocks for private subnets"
    type = list(string)
    default = [
        "10.0.101.0/24",
        "10.0.102.0/24",
        "10.0.103.0/24",
        "10.0.104.0/24"
    ]
}

variable "db_username" {
    description = "database master user"
    sensitive = true
}

variable "db_password" {
    description = "database master pwd"
    sensitive = true
}