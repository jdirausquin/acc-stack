variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}
variable "amis" {
    description = "AMIs by region"
    default = {
        us-west-2 = "ami-8d0c07f4" # Windows Server 2012 R2 Standar
    }
}

variable "key_name" {
    default = "devops"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "172.33.0.0/16"
}

variable "subnet_pub_cidr_a" {
    description = "CIDR for the Public Subnet AZ a"
    default = "172.33.1.0/24"
}

variable "subnet_pub_cidr_b" {
    description = "CIDR for the Public Subnet AZ b"
    default = "172.33.2.0/24"
}

variable "subnet_pri_cidr_a" {
    description = "CIDR for the Private Subnet AZ a"
    default = "172.33.10.0/24"
}

variable "subnet_pri_cidr_b" {
    description = "CIDR for the Private Subnet AZ b"
    default = "172.33.11.0/24"
}
