app_name        = "TBD"
app_environment = "dev"

vpc_cidr           = "10.11.0.0/16"
public_subnet_cidr = "10.11.1.0/24"

aws_access_key = "insert-access-key-here"
aws_secret_key = "insert-access-key-here"
aws_region     = "us-east-1"

linux_instance_type               = "t2.micro"
linux_associate_public_ip_address = true
linux_root_volume_size            = 20
linux_root_volume_type            = "gp2"
linux_data_volume_size            = 100
linux_data_volume_type            = "gp2"