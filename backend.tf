terraform {
    backend "s3" {
        bucket = "aws_s3_bucket.buddy.id"
        key = "network/terraform.tfstate"
        region = "ap-south-1"
    }
}