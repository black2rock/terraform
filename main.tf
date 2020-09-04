resource "aws_iam_user" "administrators" {
    count = length(var.administrators)
    name  = element(var.administrators, count.index)
    path = "/"
    force_destroy = true
    tags = {
        Name = element(var.administrators, count.index),
    }
}

resource "aws_iam_user" "developers" {
    count = length(var.developers)
    name  = element(var.developers, count.index)
    path = "/"
    force_destroy = true
    tags = {
        Name = element(var.developers, count.index),
    }
}

resource "aws_iam_user" "operators" {
    count = length(var.operators)
    name  = element(var.operators, count.index)
    path = "/"
    force_destroy = true
    tags = {
        Name = element(var.operators, count.index),
    }
}

resource "aws_iam_group" "iam_groups" {
    count = length(var.iam_groups)
    name = element(var.iam_groups, count.index)
    path = "/"
}

resource "aws_iam_account_password_policy" "iam_account_password_policy" {
    minimum_password_length = 8
    require_lowercase_characters = true
    require_numbers = true
    require_uppercase_characters = true
    require_symbols = true
    allow_users_to_change_password = true
}

resource "aws_iam_group_membership" "administrators" {
    name = "Administrators-group-membership"
    users = var.administrators
    group = var.iam_groups[0]
}

resource "aws_iam_group_membership" "developers" {
    name = "Administrators-group-membership"
    users = var.developers
    group = var.iam_groups[1]
}

resource "aws_iam_group_membership" "operators" {
    name = "Administrators-group-membership"
    users = var.operators
    group = var.iam_groups[2]
}

#resource "aws_iam_group_policy" "administrators_policy" {
#    name = "administrators_policy"
#    #group = aws_iam_group.iam_groups.id
#    policy = file("administrators.json")
#}

data "aws_iam_policy" "AdministratorAccess" {
    arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "PowerUserAccess" {
    arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

data "aws_iam_policy" "OperatorAccess" {
    arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

#resource "aws_iam_policy" "administrators" {
#    name = "administrators_policy"
#    #group = aws_iam_group.iam_groups.id
#    policy = file("./iam_policy/administrators.json")
#}

resource "aws_iam_group_policy_attachment" "administrators-attach" {
    group = var.iam_groups[0]
    #policy_arn = aws_iam_policy.administrators.arn
    policy_arn = data.aws_iam_policy.AdministratorAccess.arn
}

#resource "aws_iam_policy" "developers" {
#    name = "developers_policy"
#    #group = aws_iam_group.iam_groups.id
#    policy = file("./iam_policy/developers.json")
#}

resource "aws_iam_group_policy_attachment" "developers-attach" {
    group = var.iam_groups[1]
    #policy_arn = aws_iam_policy.developers.arn
    policy_arn = data.aws_iam_policy.PowerUserAccess.arn
}

#resource "aws_iam_policy" "operators" {
#    name = "operators_policy"
#    #group = aws_iam_group.iam_groups.id
#    policy = file("./iam_policy/operators.json")
#}

resource "aws_iam_group_policy_attachment" "operators-attach" {
    group = var.iam_groups[2]
    #policy_arn = aws_iam_policy.operators.arn
    policy_arn = data.aws_iam_policy.OperatorAccess.arn
}

resource "aws_iam_user_login_profile" "administrators" {
    count = length(var.administrators)
    user = element(var.administrators, count.index)
    pgp_key = var.pgp_key
    password_reset_required = true
}

resource "aws_iam_user_login_profile" "developers" {
    count = length(var.developers)
    user = element(var.developers, count.index)
    pgp_key = var.pgp_key
    password_reset_required = true
}

resource "aws_iam_user_login_profile" "operators" {
    count = length(var.operators)
    user = element(var.operators, count.index)
    pgp_key = var.pgp_key
    password_reset_required = true
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "DevVPC"
    cidr = "10.0.0.0/16"
    azs = ["ap-northeast-1a", "ap-northeast-1c"]
    private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    
    enable_nat_gateway = false
    enable_vpn_gateway = false
    enable_dns_support = true
    enable_dns_hostnames = true

    create_igw = true

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

resource "aws_route_table" "public-route" {
    vpc_id = module.vpc.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = module.vpc.igw_id
    }
}
 
resource "aws_route_table_association" "puclic-rt-association1" {
    subnet_id = module.vpc.public_subnets[0]
    route_table_id = aws_route_table.public-route.id
}
 
resource "aws_security_group" "admin" {
    name = "admin"
    description = "Allow SSH inbound traffic"
    vpc_id = module.vpc.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.public_ingress_cidr_blocks
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#module "public_sg" {
#    source = "terraform-aws-modules/security-group/aws"
#    name = "public_subnet_sg"
#    description = "Security group for public subnet."
#    vpc_id = aws_vpc.vpc.vpc_id
#
#    ingress_cider_blocks = ["106.161.109.152.32"]
#    ingress_rule = ["ssh-22-tcp"]
#    ingress_with_cidr_blocks = [
#        {
#            from_port = 22
#            #to_port = 22
#            protocol = "tcp"
#            description = "SSH ports"
#            cidr_blocks = "xxxxx"
#        },
#        {
#            rule = "xxxx-tcp"
#            cidr_bloks = "0.0.0.0/0"
#        }
#    ]
#}