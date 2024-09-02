terraform {
  backend "s3" {
    bucket = "aap-template-tfstate"
    key    = "terraform_makepipeline.tfstate"
    region = var.region
    # dynamodb_table = "aap-infra-pipeline"
    encrypt = true
    profile = var.profile
  }
  required_version = "1.1.4"
}