resource "aws_codebuild_project" "main" {
  name          = var.project_name
  description   = "${var.project_name} ecs pipeline"
  build_timeout = 60
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }
  cache {
    type  = "LOCAL"
    modes = ["LOCAL_CUSTOM_CACHE"]
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = aws_cloudwatch_log_group.codebuild.name
    }
    s3_logs {
      status = "DISABLED"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "EXECUTION_ROLE_ARN"
      value = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "LOGGROUP_NAME"
      value = aws_cloudwatch_log_group.ecs.name
    }

    environment_variable {
      name  = "TASK_FAMILY"
      value = aws_ecs_task_definition.task_definition.family
    }
  }
}
