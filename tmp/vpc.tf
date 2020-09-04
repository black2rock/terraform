resource "aws_vpc" "terraformVPC" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    //tags {
    //    Name = "terrafromVPC"
    //}
}

resource "aws_internet_gateway" "terraformIGW" {
    vpc_id = aws_vpc.terraformVPC.id # idを参照(ver.0.12以降は${}は不要に)
    //depends_on = ["aws_vpc.terraformVPC"]
}

resource "aws_subnet" "public-a" {
    vpc_id = aws_vpc.terraformVPC.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private-a" {
    vpc_id = aws_vpc.terraformVPC.id
    cidr_block = "10.0.101.0/24"
    availability_zone = "ap-northeast-1a"
}