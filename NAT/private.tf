provider "aws" {
    region = "us-east-1"
    access_key = "hide"
    secret_key = "hide"
}

// DB

resource "aws_security_group" "db" {
    name = "vpc_db"
    description = "DB"

    ingress {
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
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

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "DBSG"
    }
}

resource "aws_instance" "db" {
    ami = "ami-06b263d6ceff0b3dd"
    region = "us-east-1"
    availability_zone = "us-east-1b"
    instance_type = "t2.micro"
    key_name = "demo_pem"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    subnet_id = "${aws_subnet.us-east-1b-private.id}"
    source_dest_check = false

    tags {
        Name = "DB"
    }
}