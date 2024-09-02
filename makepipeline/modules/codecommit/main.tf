resource "aws_codecommit_repository" "this" {
  repository_name = var.repository_name
  description     = "This is the Sample App Repository"
  tags = {
    Name = var.repository_name
  }
}