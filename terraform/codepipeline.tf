resource "aws_codepipeline" "main" {
  name     = var.project_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.pipeline_artifact.id
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codestarconnections_connection.arn
        FullRepositoryId = "ShugoYabuno/${var.project_name}"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 2
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      configuration = {
        ProjectName = var.project_name
      }
    }
  }
}

resource "aws_codestarconnections_connection" "codestarconnections_connection" {
  name          = "${var.project_name}-connection"
  provider_type = "GitHub"
}
