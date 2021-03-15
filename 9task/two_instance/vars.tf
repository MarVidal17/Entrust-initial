variable "AWS_REGION" {    
    default = "eu-west-1"
}

variable "AWS_ZONE" {    
    default = "eu-west-1a"
}

variable "EC2_USER" {    
    default = "ec2-user"
}

variable "MY_IP" {    
    default = "213.27.152.98/32"
}

variable "KEY_NAME" {    
    default = "mar_vidal"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "10.0.1.0/24"
}