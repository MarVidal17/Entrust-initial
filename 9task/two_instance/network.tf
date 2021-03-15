resource "aws_internet_gateway" "test-mvs-igw" {
    vpc_id = aws_vpc.test-mvs-vpc.id
    tags = {
        Name = "test-mvs-igw"
    }
}

resource "aws_route_table" "test-mvs-public-crt" {
    vpc_id = aws_vpc.test-mvs-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"         
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

resource "aws_security_group" "mvs-public-sg" {
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
    
    tags = {
        Name = "mvs-public-sg"
    }
}

resource "aws_eip" "nat_gw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.test-mvs-subnet-public-1.id
}

resource "aws_route_table" "test-mvs-private-crt" {
    vpc_id = aws_vpc.test-mvs-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gw.id
    }

    tags = {
        Name = "Main Route Table for NAT-ed subnet"
    }
}

resource "aws_route_table_association" "test-mvs-crta-private-subnet-1" {
    subnet_id = aws_subnet.test-mvs-subnet-private-1.id
    route_table_id = aws_route_table.test-mvs-private-crt.id
}

resource "aws_security_group" "mvs-private-sg" {
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
        cidr_blocks = [var.vpc_cidr]
    }
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }    
    
    tags = {
        Name = "mvs-private-sg"
    }
}