variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "ap-northeast-1"
    description = "AWS Region"
}

variable "image_id" {
    default = "ami-6b0d5f0d"
    description = "AMI id"
}

variable "administrators" {
    default = [
        "test1",
        "test2",
        "test3",
    ]
    description = "IAM users for Administrator"
}

variable "developers" {
    default = [
        "test4",
        "test5",
        "test6",
    ]
    description = "IAM users for Developers"
}

variable "operators" {
    default = [
        "test7",
        "test8",
        "test9",
    ]
    description = "IAM users for Operators"
}

variable "iam_groups" {
    default = [
        "Administrators",
        "Developers",
        "Operators",
    ]
    description = "IAM groups"
}

variable "public_ingress_cidr_blocks" {
    default = []
}

variable "pgp_key" {}