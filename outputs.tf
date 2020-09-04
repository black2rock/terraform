output "vpc_id" {
    description = "The ID of the VPC"
    value = module.vpc.vpc_id
}

output "private_subnets" {
    description = "List of IDs of private subnets"
    value = module.vpc.private_subnets
}

output "public_subnets" {
    description = "List of IDs of private subnets"
    value = module.vpc.public_subnets
}

#output "nat_public_ips" {
#    description = "List of public Elastic IPs created for AWS NAT Gateway"
#    value = module.vpc.nat_public_ips
#}
#
#output "vpc_endpoint_ssm_id" {
#    description = "The ID of VPC endpoint for SSM"
#    value = module.vpc.vpc_endpoint_ssm_id
#}

output "administrators_name" {
    value = aws_iam_user.administrators.*.name
}

output "developers_name" {
    value = aws_iam_user.developers.*.name
}

output "operators_name" {
    value = aws_iam_user.operators.*.name
}

output "administrators_passwords" {
    value = aws_iam_user_login_profile.administrators.*.encrypted_password
}

output "developers_passwords" {
    value = aws_iam_user_login_profile.developers.*.encrypted_password
}

output "operators_passwords" {
    value = aws_iam_user_login_profile.operators.*.encrypted_password
}