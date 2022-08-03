provider "aws" {
    region = "us-east-1"
    access_key = "hide"
    secret_key = "hide"
}

// web

resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "HTTP"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }
    egress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "WebSG"
    }
}

resource "aws_instance" "web-1" {
    ami = "ami-06b263d6ceff0b3dd"
    region = "us-east-1"
    availability_zone = "us-east-1b"
    instance_type = "t2.micro"
    key_name = "demo_pem"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.us-east-1b-public.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags {
        Name = "Web Server 1"
    }
}

resource "aws_eip" "web-1" {
    instance = "${aws_instance.web-1.id}"
    vpc = true
}