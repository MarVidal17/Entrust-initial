resource "aws_internet_gateway" "test-mvs-igw" {
    vpc_id = aws_vpc.test-mvs-vpc.id
    tags = {
        Name = "test-mvs-igw"
    }
}

resource "aws_route_table" "test-mvs-public-crt" {
    vpc_id = aws_vpc.test-mvs-vpc.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"         
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.test-mvs-igw.id
    }
    
    tags = {
        Name = "test-mvs-public-crt"
    }
}

resource "aws_route_table_association" "test-mvs-crta-public-subnet-1"{
    subnet_id = aws_subnet.test-mvs-subnet-public-1.id
    route_table_id = aws_route_table.test-mvs-public-crt.id
}

resource "aws_security_group" "ssh-allowed" {
    vpc_id = aws_vpc.test-mvs-vpc.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }    
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.MY_IP]
    }
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.MY_IP]
    }    
    
    tags = {
        Name = "ssh-allowed"
    }
}