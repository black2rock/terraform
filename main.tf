variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "ap-northeast-1"
}

variable "images" {
    default = {
        #ap-northeast-1 = "ami-0dd27e221a6e3c2f2"
        ap-northeast-1 = "ami-6b0d5f0d"
    }
}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
} 

resource "aws_vpc" "terraformVPC" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    tags {
        Name = "terrafromVPC"
    }
}

resource "aws_internet_gateway" "terraformIGW" {
    vpc_id = "${aws_vpc.terraformVPC.id}" # idを参照
    depends_on = ["aws_vpc.terraformVPC"]
}

resource "aws_subnet" "public-a" {
    vpc_id = "${aws_vpc.terraformVPC.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"
}
 
resource "aws_route_table" "public-route" {
    vpc_id = "${aws_vpc.terraformVPC.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.terraformIGW.id}"
    }
}
 
resource "aws_route_table_association" "puclic-rt-association1" {
    subnet_id = "${aws_subnet.public-a.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}
 
resource "aws_security_group" "admin" {
    name = "admin"
    description = "Allow SSH inbound traffic"
    vpc_id = "${aws_vpc.terraformVPC.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["106.161.109.152/32"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
 
resource "aws_instance" "tf-test" {
    ami = "${var.images["ap-northeast-1"]}"
    instance_type = "t3.micro"
    key_name = "ec2instance_20170516"
    vpc_security_group_ids = [
      "${aws_security_group.admin.id}"
    ]
    subnet_id = "${aws_subnet.public-a.id}"
    associate_public_ip_address = "true"
    root_block_device = {
      volume_type = "gp2"
      volume_size = "20"
    }
    ebs_block_device = {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = "100"
    }
    #user_data = <<EOF
    tags {
        Name = "tf-test"
    }
}
 
output "public ip of tf-test" {
  value = "${aws_instance.tf-test.public_ip}"
}