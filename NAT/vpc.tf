provider "aws" {
    region = "us-east-1"
    access_key = "AKIAJRJJ3XTM62H5ASAA"
    secret_key = "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"
}

resource "aws_vpc" "default" {
    default = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

// NAT

resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "NATSG"
    }
}

resource "aws_instance" "nat" {
    ami = "ami-30913f47" // NAT
    availability_zone = "us-east-1b"
    instance_type = "t2.micro"
    key_name = "demo_pem"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.us-east-1b-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "VPC NAT"
    }
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}

// Public

resource "aws_subnet" "us-east-1b-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = ["10.0.0.0/24"]
    availability_zone = "us-east-1b"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-east-1b-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = ["0.0.0.0/0"]
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-east-1b-public" {
    subnet_id = "${aws_subnet.us-east-1b-public.id}"
    route_table_id = "${aws_route_table.us-east-1b-public.id}"
}

// Private

resource "aws_subnet" "us-east-1b-private" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = ["10.0.1.0/24"]
    availability_zone = "us-east-1b"

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table" "us-east-1b-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = ["0.0.0.0/0"]
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "us-east-1b-private" {
    subnet_id = "${aws_subnet.us-east-1b-private.id}"
    route_table_id = "${aws_route_table.us-east-1b-private.id}"
}