resource "aws_codepipeline" "this" {
  name     = var.codepipeline_name
  role_arn = var.role_arn

  artifact_store {
    location = var.artifact_store_location
    type     = var.artifact_store_type
  }

  dynamic "stage" {
    for_each = var.stage

    content {
      name = stage.value["name"]

      dynamic "action" {
        for_each = stage.value["action"]
        content {
          run_order        = action.value["run_order"]
          name             = action.value["name"]
          category         = action.value["category"]
          owner            = action.value["owner"]
          provider         = action.value["provider"]
          version          = action.value["version"]
          input_artifacts  = try(action.value["input_artifacts"], null)
          output_artifacts = try(action.value["output_artifacts"], null)
          configuration    = action.value["configuration"]
        }
      }
    }
  }

  tags = {
    Name = var.codepipeline_name
  }
}
