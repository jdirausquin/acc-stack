variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "aws_az_a" {
    description = "EC2 AZ a"
    default = "us-east-1a"
}

variable "aws_az_b" {
    description = "EC2 AZ b"
    default = "us-east-1b"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-f4d1f0e2" # Windows Server 2012 R2 Standar
    }
}

variable "aws_instance_type" {
    description = "EC2 instance type" 
    default = "t1.micro"
}

variable "aws_key_name" {
    default = "devops"
}

variable "company_network" {
    description = "CIDR for the whole company"
    default = "172.16.0.0/12"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "172.16.0.0/16"
}

variable "subnet_pub_cidr_a" {
    description = "CIDR for the Public Subnet AZ a"
    default = "172.16.1.0/24"
}

variable "subnet_pub_cidr_b" {
    description = "CIDR for the Public Subnet AZ b"
    default = "172.16.2.0/24"
}

variable "subnet_pri_cidr_a" {
    description = "CIDR for the Private Subnet AZ a"
    default = "172.16.10.0/24"
}

variable "subnet_pri_cidr_b" {
    description = "CIDR for the Private Subnet AZ b"
    default = "172.16.11.0/24"
}

variable "vpc_omn_dev" {
    default = "vpc-123456"
}
variable "vpc_omn_qa" {
    default = "vpc-654321"
}

provider "aws" {
    region  = "${var.aws_region}"
}
