resource "aws_vpc" "test-mvs-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"    
    
    tags = {
        Name = "test-mvs-vpc"
    }
}

resource "aws_subnet" "test-mvs-subnet-public-1" {
    vpc_id = aws_vpc.test-mvs-vpc.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = var.AWS_ZONE 
    
    tags = {
        Name = "test-mvs-subnet-public-1"
    }
}

resource "aws_subnet" "test-mvs-subnet-private-1" {
    vpc_id = aws_vpc.test-mvs-vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.AWS_ZONE 
    
    tags = {
        Name = "test-mvs-subnet-private-1"
    }
}
