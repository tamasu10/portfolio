terraform {
  backend "s3" {
    bucket = "aap-template-tfstate"
    key    = "terraform_codepipeline.tfstate"
    region = var.region
    # dynamodb_table = "aap-infra-pipeline"
    encrypt = true
    profile = var.profile
  }
  required_version = "1.1.4"
}