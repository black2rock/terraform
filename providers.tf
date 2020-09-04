provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region = var.region
    //version = "~> 1.60"
    version = "~> 2.0"
} 