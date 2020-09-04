resource "aws_instance" "tf-test" {
    ami = var.images["ap-northeast-1"]
    instance_type = "t3.micro"
    key_name = "ec2instance_20170516"
    vpc_security_group_ids = [
      aws_security_group.admin.id
    ]
    subnet_id = aws_subnet.public-a.id
    associate_public_ip_address = "true"
    //root_block_device = {
    //  volume_type = "gp2"
    //  volume_size = "20"
    //}
    //ebs_block_device = {
    //  device_name = "/dev/sdf"
    //  volume_type = "gp2"
    //  volume_size = "100"
    //}
    #user_data = <<EOF
    //tags {
    //    Name = "tf-test"
    //}
}