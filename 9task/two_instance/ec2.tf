resource "aws_instance" "bastion" {
    ami = "ami-0bb3fad3c0286ebd5"
    instance_type = "t2.micro"    
    
    # VPC
    subnet_id = aws_subnet.test-mvs-subnet-public-1.id    
    
    # Security Group
    vpc_security_group_ids = [aws_security_group.mvs-public-sg.id]    
    
    # the Public SSH key
    key_name = var.KEY_NAME 

    associate_public_ip_address = true

    tags = {
        Name = "mvs-bastion-instance"
    }
    
}

resource "aws_instance" "server" {
    ami = "ami-0bb3fad3c0286ebd5"
    instance_type = "t2.micro"    
    
    # VPC
    subnet_id = aws_subnet.test-mvs-subnet-private-1.id    
    
    # Security Group
    vpc_security_group_ids = [aws_security_group.mvs-private-sg.id]    
    
    # the Public SSH key
    key_name = var.KEY_NAME 
    
    associate_public_ip_address = false

    tags = {
        Name = "mvs-server-instance"
    }
}
