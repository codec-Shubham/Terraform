resource "aws_security_group" "security_group" {
    description = "Allow limited inbound external traffic"
    vpc_id = "${aws_vpc.devopshint_vpc.id}"
    name = "terraform_ec2_private_sg"

    ingress {
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port = 22
        to_port = 22
    }

     ingress {
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port = 8080
        to_port = 8080
    }

     ingress {
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port = 443
        to_port = 443
    }

    egress {
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port = 0
        to_port = 0
    }
    tags ={
        Name="ec2-private-sg"
    }
}

output "aws_security_group_id" {
  value = "${aws_security_group.security_group.id}"
}

resource "aws_instance" "public_instance" {
    ami = "ami-0c1a7f89451184c8b"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ "${aws_security_group.security_group.id}" ]
    subnet_id = "${aws_subnet.public_subnet.id}"
    key_name = "newkey"
    count = 1
    associate_public_ip_address = true
    tags = {
      Name = "public_instance"
    }
  
}


resource "aws_instance" "private_instance" {
    ami = "ami-0c1a7f89451184c8b"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ "${aws_security_group.security_group.id}" ]
    subnet_id = "${aws_subnet.private_subnet.id}"
    key_name = "newkey"
    count = 1
    associate_public_ip_address = false
    tags = {
      Name = "private_instance"
    }
  
}


