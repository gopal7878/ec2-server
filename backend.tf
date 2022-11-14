terraform {
    backend "s3" {
        bucket = var.default_state_bucket
        key = "terraform/deployment/accounts/${var.clp_account}/regions/${var.clp_region}/vpc/networking/vpc_base/terraform.tfstate"
        region = var.default_region
    }
}
