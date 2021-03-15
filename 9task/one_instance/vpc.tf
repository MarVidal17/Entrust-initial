resource "aws_vpc" "test-mvs-vpc" {
    cidr_block = "10.0.0.0/16"
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
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = var.AWS_ZONE 
    
    tags = {
        Name = "test-mvs-subnet-public-1"
    }
}
