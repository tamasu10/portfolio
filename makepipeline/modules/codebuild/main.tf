resource "aws_codebuild_project" "this" {
  name          = var.codebuild_name
  service_role  = var.service_role

  artifacts {
    type = var.artifacts_type
  }

  dynamic "environment" {
    for_each = var.environment

    content {
      compute_type                = environment.value["compute_type"]
      image                       = environment.value["image"]
      type                        = environment.value["type"]
      image_pull_credentials_type = environment.value["image_pull_credentials_type"]

      dynamic "environment_variable" {
        for_each = environment.value["environment_variable"]
        content {
          name  = environment_variable.value["name"]
          value = environment_variable.value["value"]
        }
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.cloudwatch_logs_group_name
      stream_name = var.cloudwatch_logs_stream_name
    }
  }

  source {
    type     = var.source_type
    location = var.source_location
  }

  source_version = var.source_version

  tags = {
    Name = var.codebuild_name
  }
}
