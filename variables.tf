variable "region" {
    description = "AWS region to deploy resources"
    type        = string
    
}

variable "avaibility_zones" {
    description = "List of availability zones to use for subnets"
    type        = list(string)
  
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
  
}

variable "public_subnet_cidrs" {
    description = "List of CIDR blocks for public subnets"
    type        = list(string)
  
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
  
}

variable "key_name" {
    description = "Name of the SSH key pair to access EC2 instances"
    type        = string
  
}
