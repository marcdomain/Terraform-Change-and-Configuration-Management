variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "subnets_cidr" {
  type    = "list"
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "app" {
  type    = "list"
  default = ["frontend", "backend"]
}

variable "azs" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b"]
}

# variable "frontend_ami" {
#   default = "ami-043eb1541e0383582"
# }


# variable "backend_ami" {
#   default = "ami-0d9a61d15564880c0"
# }

